sslh Cookbook
=============
This cookbook installs and configures [sslh](http://www.rutschle.net/tech/sslh.shtml)

Requirements
------------
#### operating systems
- Cent OS 6.x

Attributes
----------

#### sslh::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>["sslh"]["source"]["version"]</tt></td>
    <td>String</td>
    <td>sslh version</td>
    <td>1.15</td>
  </tr>
  <tr>
    <td><tt>["sslh"]["source"]["checksum"]</tt></td>
    <td>String</td>
    <td>Checksum of sslh package</td>
    <td>fc854cc5d95be2c50293e655b7427032ece74ebef1f7f0119c0fc3e207109ccd</td>
  </tr>
  <tr>
    <td><tt>["sslh"]["options"]</tt></td>
    <td>String</td>
    <td>sslh options</td>
    <td>--user nobody --pidfile $PIDFILE -p  0.0.0.0:8443 --ssl 127.0.0.1:443 --ssh 127.0.0.1:22</td>
  </tr>
</table>

Usage
-----
#### sslh::default
Just include `sslh` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sslh]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: OKAMURA Yasunobu (okamura@informationsea.info)
