package tests

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestCanConfigureRegistryScanningConfigurationRule(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("test-%d", random.Random(0, 10))

	region := aws.GetRandomRegion(t, nil, nil)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name": expectedName,
			"registry_scanning_configuration": map[string]interface{}{
				"scan_type": "ENHANCED",
				"rules": []map[string]interface{}{
					{
						"scan_frequency": "CONTINUOUS_SCAN",
						"repository_filter": map[string]interface{}{
							"filter": "*",
						},
					},
				},
			},
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	_, err := terraform.InitAndApplyE(t, terraformOptions)
	require.NoError(t, err)
}
