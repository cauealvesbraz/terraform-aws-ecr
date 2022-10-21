package tests

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestDefaultEncryptionTypeConfigurationMustBeAES256(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("test-%d", random.Random(0, 10000))

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
}
