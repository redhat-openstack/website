---
title: Using Dell EqualLogic for Cinder with RDO
authors: tshefi
---

# Using Dell EqualLogic for Cinder with RDO

## Configuring Cinder

On the RDO node, configure the Cinder configuration file. The default configuration file has commented out sections for Ceph, which you can uncomment and configure.

1. As root, edit the `/etc/cinder/cinder.conf` file.

2. Add the volume driver.

          volume_driver = cinder.volume.drivers.eqlx.DellEQLSanISCSIDriver

3. Add EqualLogic's SSH ip: `san_ip = X.Y.Z.W`.

4. Add EqualLogic's SSH user: `san_login = SSHuser`.

5. Add EqualLogic's SSH password: `san_password = SSHPassword`.

6. Add EqualLogic's default pool name: `eqlx_pool = default`.

*   Note your default pool name may vary.

7. Add EqualLogic's group name: `eqlx_group_name = PS6000-group`.

*   Note your group name may vary.

8. Save changes to the configuration file.

9. Restart Cinder, #openstack-service restart cinder

Further details and options can be found at: [1](http://docs.openstack.org/trunk/config-reference/content/dell-equallogic-driver.html)
