# Kodi Six

Kodi Six is an experimental library created to simplify porting Kodi Python
addons to Python 3.

## Rationale

The current Kodi Python API that is based on Python 2.7 handles string data
inconsistently. Some functions accept non-ASCII strings only as `str` objects
encoded in UTF-8, while other functions and methods accept both `str` and
`unicode`. Also, most functions and methods that return text data return `str`
objects also encoded in UTF-8, but a few of them return `unicode`.
This makes addon developers to use *ad hoc* solutions for each case. For example,
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

* Kodi Six wrappers normalize only string arguments and return values.
  They do not touch strings inside containers like Python lists and dictionsries.
* Kodi Six is an experimental library, so issue may happen in specific cases.

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
xbmc.log(some_string)  # No need to and encode the string
```

## License

[GPL v.3](https://www.gnu.org/licenses/gpl-3.0.en.html)
