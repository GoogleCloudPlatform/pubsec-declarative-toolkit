# FortiGate licensing: BYOL

BYOL licenses are traditional pre-paid licenses purchased for a predefined VM size and time. Once purchased from Fortinet reseller BYOL licenses must be activated in Fortinet customer portal, after activation you will be able to download license key file (*.lic file) which can be used to activate a VM instance.

Other licensing options for FortiGate supported by this module are:
- [PAYG](../licensing-payg)
- [FortiFlex](../licensing-flex)

## Configuration

Using BYOL licenses requires use of BYOL boot image. Please make sure to **NOT** use the default image or any image with "ondemand" name or "payg" family name to avoid double license fees. This module supports automated bootstrapping images with BYOL licenses. Copy two *.lic files to the location of your terraform root config and provide a list with the file names as `license_files` variable to the module.

```
license_files = [
  "license_file1.lic",
  "license_file2.lic"
  ]
```

See [docs/images.md](../../docs/images.md) for more information on obtaining images.

## Example

See [main.tf](main.tf) file for example code.
