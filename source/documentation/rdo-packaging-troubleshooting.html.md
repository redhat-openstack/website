---
:author: hguemar
---

# RDO OpenStack Packaging Troubleshooting

## FAQ

### My EPEL branch request has been denied


EPEL rules exclude packages that in a limited set of channels of
RHEL but Fedora Releng uses a generated list of packages to filter
branch requests. Check first that your package is not listed
[there](http://infrastructure.fedoraproject.org/repo/json/pkg_el7.json)
by mistake

