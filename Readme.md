# Kodi Six

Kodi Six is an experimental library created to simplify porting Kodi Python
addons to Python 3.

## Rationale

The current Kodi Python API that is based on Python 2.7 handles string data
inconsistently. Some functions accept non-ASCII strings only as `str` objects
encoded in UTF-8, while other functions and methods accept both `str` and
`unicode`. Also, most functions and methods that return text data return `str`
objects also encoded in UTF-8, but a few of them return `unicode`.
This makes addon developers use *ad hoc* solutions for each case. For example,
strings that are passed to `xbmc.log()` function need to be checked if they are
`unicode` objects and, if yes, encoded to `str` using UTF-8.

In test Kodi builds with Python 3 interpreter Kodi Python API functions and
methods accept and return text data only as Unicode strings
(`str` type in Python 3) so the previously mentioned *ad hoc* solutions
won't work. For example, in Python 3 `xbmc.log()` won't accept UTF-8 encoded
`bytes` strings.

Kodi Six wraps Kodi Python API functions and methods to normalize string
handling in Python 2. All wrapped functions and methods that receive string
arguments accept both `unicode` and UTF-8 encoded `str` objects, and those that
return string data return `unicode`. This eliminates the need to use *ad hoc*
string encoding and decoding because now those functions and methods behave
similarly in Python 2 and 3 Kodi API.

In Python 3 those wrappers do not do anything.

## Important Notes

* Kodi Six is an experimental library, so issues may happen in specific cases.
* Kodi Six wrappers normalize only string arguments and return values.
  They do not touch strings inside containers like Python lists and dictionaries.

## Usage

Add `script.module.kodi-six` to your addon dependencies:
```xml
<requires>
  ...
  <import addon="script.module.kodi-six" />
</requires>
```

In your addon simply import necessary Kodi API modules from `kodi_six` package:

```python
from kodi_six import xbmc, xbmcaddon, xbmcplugin, xbmcgui, xbmcvfs
```

## Example

Python 2:
```python
# coding: utf-8

import xbmc
import xbmcaddon

addon = xbmcaddon.Addon()
# path is returned as str and needs to be decoded to unicode
path = addon.getAddonInfo('path').decode('utf-8')  # This will break in Python 3!

some_string = u'текст українською мовою'
# xbmc.log won't accept non-ASCII Unicode
xbmc.log(some_string.encode('utf-8'))  # This will break in Python 3 too!
```

Python 2 and 3:
```python
# coding: utf-8

from kodi_six import xbmc, xbmcaddon

addon = xbmcaddon.Addon()
# No need to decode the path, it is already unicode
path = addon.getAddonInfo('path')

some_string = u'текст українською мовою'
xbmc.log(some_string)  # No need to encode the string
```

## Known Issues

* `xbmcvfs.File.read()` can read only textual files in UTF-8
  (or pure ASCII as a subset of UTF-8) encoding.
  For binary (non-textual) files `xbmcvfs.File.readBytes()` instead.
  Textual files with encodings other than UTF-8 should be read as binary
  files and decoded using the appropriate encoding:
  
```python
from contextlib import closing
from kodi_six import xbmcvfs

with closing(xbmcvfs.File('/path/to/my/file.txt')) as fo:
    byte_string = bytes(fo.readBytes())
test_string = byte_string.decode('utf-16')
```

## Utility Functions

Kodi Six also provides convenience conditional functions for string encoding
and decoding for cases when some API require/return `str` (bytes) in Python 2
and `str` (Unicode) in Python 3. Those functions can be used to normalize string
handling in both Python versions.

```python
# coding: utf-8

from kodi_six.utils import py2_encode, py2_decode

spam = u'спам'

b = py2_encode(spam)  # Encode Unicode to str only in Python 2

u = py2_decode(b)  # Decode str to Unicode only in Python 2

# In Python 3 the Unicode string is not changed.
```

## License

[GPL v.3](https://www.gnu.org/licenses/gpl-3.0.en.html)
