1. running on VM

if you're running it on VM(libvirt), you need entropy device, add this to xml file.

```bash
  <devices>
    <rng model='virtio'>
      <rate period="2000" bytes="1234"/>
      <backend model='random'>/dev/random</backend>
    </rng>
  </devices>
```
