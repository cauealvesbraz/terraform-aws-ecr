package tests

import (
	"encoding/json"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestCanCreateRepositoryWithEmptyLifecyclePolicy(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("test-%d", random.Random(0, 10))

	region := aws.GetRandomRegion(t, nil, nil)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name": expectedName,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	repository := aws.GetECRRepo(t, region, expectedName)

	assert.Equal(t, "AES256", *repository.EncryptionConfiguration.EncryptionType)
	assert.Equal(t, "IMMUTABLE", *repository.ImageTagMutability)
	assert.True(t, *repository.ImageScanningConfiguration.ScanOnPush)
}

func TestCanCreateRepositoryWithLifecyclePolicyAndTaggedStatus(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("test-%d", random.Random(0, 10))

	region := aws.GetRandomRegion(t, nil, nil)

	lifecyclePolicy := map[string]interface{}{
		"rules": []map[string]interface{}{
			{
				"rulePriority": 1,
				"description":  "Expire images older than 14 days",
				"selection": map[string]interface{}{
					"tagStatus":     "tagged",
					"countType":     "sinceImagePushed",
					"countUnit":     "days",
					"countNumber":   14,
					"tagPrefixList": []string{"test-repo"},
				},
				"action": map[string]interface{}{
					"type": "expire",
				},
			},
		},
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":             expectedName,
			"lifecycle_policy": lifecyclePolicy,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	repository := aws.GetECRRepo(t, region, expectedName)
	currentPolicy := aws.GetECRRepoLifecyclePolicy(t, region, repository)

	lifecyclePolicyJson, _ := json.Marshal(lifecyclePolicy)
	assert.JSONEq(t, string(lifecyclePolicyJson), currentPolicy)
}
