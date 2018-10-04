# -*- mode:python; tab-width:4; c-basic-offset:4; intent-tabs-mode:nil; -*-
# ex: filetype=python tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent smartindent

# Modules
from distutils.core import setup
import os

# Setup
setup(
    name = 'dovecot-loadbalancer',
    description = 'Dovecot Load-Balancer',
    long_description = \
"""
Dovecot Load-Balancer (daemon and control utility)

This small python script - along with the required PostgreSQL database -
allows to define and monitor actual Dovecot servers and provide load-balancing
and high-availability for the Dovecot services.
""",
    version = os.getenv('VERSION'),
    author = 'Cedric Dufour',
    author_email = 'http://cedric.dufour.name',
    license = 'GPL-3',
    url = 'https://github.com/cedric-dufour/dovecot-loadbalancer',
    download_url = 'https://github.com/cedric-dufour/dovecot-loadbalancer',
    requires = [ 'configobj', 'daemon', 'psycopg2' ],
    scripts = [ 'dovecot-loadbalancer' ],
    )
