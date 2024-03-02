# FortiGate module: GVNIC and custom image

In some cases you might want to use custom boot image instead of the one provided by Fortinet. One of these reasons is using GVNIC driver. By default images for Intel-based architecture (amd64) deploy instances with virtio driver. If you want to change it you need to create a private image with GVNIC support (FortiGate firmware already supports it, but it's not indicated in the image metadata). The easiest way to create a custom image is to copy existing public image with new options.

## Configuration

You can instruct the module to deploy using a custom image by providing `image_name` and `image_project` variables. GVNIC driver needs to be selected using `nic_type` variable. E.g.:

```
image_name    = "my-fgt-image-name"
image_project = "my-project-name"
nic_type      = "GVNIC"
```

## Example

Example code in [main.tf](main.tf) creates a new image from existing public FortiGate 7.2.4 BYOL image and deploys a cluster with GVNIC driver using the custom image.
