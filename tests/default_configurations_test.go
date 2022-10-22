package tests

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDefaultConfigurationsShouldBeCorrect(t *testing.T) {
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

}

func TestShouldReturnExceptionWithInvalidEncryptionTypeVar(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("test-%d", random.Random(11, 20))
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name": expectedName,
			"encryption": map[string]string{
				"type": "invalid-type",
			},
		},
	}

	output, err := terraform.InitAndApplyE(t, terraformOptions)

	require.Error(t, err)
	require.Contains(t, output, "The encryption type must be one of: AES256 or KMS.")
}

func TestShouldReturnExceptionWithInvalidImageTagMutabilityVar(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("test-%d", random.Random(11, 20))
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                 expectedName,
			"image_tag_mutability": "invalid-type",
		},
	}

	output, err := terraform.InitAndApplyE(t, terraformOptions)

	require.Error(t, err)
	require.Contains(t, output, "The image tag mutability must be one of: MUTABLE or IMMUTABLE")
}
