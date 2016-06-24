## 1.0.0 (base 1.0.0)
* Tweak the styling of the return block a bit.
* The return section of tooltips will always be shown, regardless of whether the type is known or not.
* Unknown return types will now no longer be shown as 'mixed', which makes it clearer to the user that documentation is missing.

## 0.6.1 (base 0.9.0)
* Updated to use the most recent version of the base service.

## 0.6.0 (base 0.8.0)
* A couple of tooltip providers have become more asynchronous, improving responsiveness.

## 0.5.0 (base 0.7.0)
* Tooltip fetching is now mostly asynchronous, which should result in less minor hickups and freezes.
* Class names after the class keyword (to start the definition) will now also show a tooltip, much like function definitions.

## 0.4.2
* Fixed the tooltip not showing when hovering over magic methods such as `__construct`.

## 0.4.1
* Catch exceptions properly.

## 0.4.0 (base 0.6.0)
* Minor bugfixes.
* Tooltips will now show up when hovering over function and method definitions as well. This is useful when you are inheriting documentation, so you can view what is actually inherited.

## 0.3.1 (base 0.5.0)
* Updated to work with the most recent service from the base package.

## 0.3.0 (base 0.4.0)
* Added tooltips for class and global constants.
* Fixed error `Cannot read property 'length' of undefined` being thrown sometimes when there was a property and a method with the same name.

## 0.2.1
* Wait for the language-php package to become activated on startup.

## 0.2.0
* Tooltips are now displayed for global functions. `[1]`

`[1]` Note that the built-in PHP functions don't have documentation that can be retrieved via reflection, so this only applies to user defined functions at the moment.

## 0.1.0
* Initial release.
