# FortiGate licensing: FortiFlex

FortiFlex (former name FlexVM) is Fortinet's licensing program allowing generating licenses for selected products using a system of "points".  FortiFlex licenses are pre-paid and charged per day of active license. Stopping instance using FortiFlex license does not stop consumption of points (although this can be automated using FortiFlex API). FortiFlex points can be purchased through Fortinet reseller network or via Google Cloud Marketplace. Licenses defined in FortiFlex portal can be assigned to VMs using **license tokens** or managed using FortiManager.

Other licensing options for FortiGate supported by this module are:
- [PAYG](../licensing-payg)
- [BYOL](../licensing-byol)

## Configuration

As FortiFlex license is a pre-paid license, it requires use of BYOL boot image. Please make sure to **NOT** use the default image or any image with "ondemand" name or "payg" family name to avoid double license fees. While the tokens can be added post-deployment using `exec vm-license` CLI command, this module supports bootstrapping instances with the license. To bootstrap newly created instances with FortiFlex licenses provide a list of 2 license tokens in `flexvm_tokens` variable:

```
flexvm_tokens = [
  "TOKEN_1",
  "TOKEN_2"
  ]
```

See [docs/images.md](../../docs/images.md) for more information on obtaining images.

## Example

See [main.tf](main.tf) file for example code.
