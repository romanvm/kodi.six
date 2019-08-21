# -*- coding: utf-8 -*-
# (c) 2018, Roman Miroshnychenko <roman1972@gmail.com>
# License: GPL v.3
from __future__ import absolute_import, division, unicode_literals
import os
from xml.dom.minidom import parse
from setuptools import setup, find_packages

this_dir = os.path.dirname(os.path.abspath(__file__))


def get_version():
    doc = parse(os.path.join(this_dir, 'script.module.kodi-six', 'addon.xml'))
    return doc.firstChild.getAttribute('version')


setup(
    name='kodi-six',
    author='Roman Miroshnychenko',
    version=get_version(),
    package_dir={'': 'script.module.kodi-six/libs'},
    packages=find_packages('./script.module.kodi-six/libs'),
    install_requires=['Kodistubs'],
    zip_safe=False
)
