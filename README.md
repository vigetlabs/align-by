# align-by package

Align text around a specified anchor.

## Usage

Imagine you have some text that looks like this:

```
import React from 'react'
import { this, that } from 'package'
import PrimaryNav from 'components/primary-nav'
import SecondaryNav from 'components/secondary-nav'
import { DuneBlaster } from 'equipment'
```

and you want to make it look like this:

```
import React           from 'react'
import { this, that }  from 'package'
import PrimaryNav      from 'components/primary-nav'
import SecondaryNav    from 'components/secondary-nav'
import { DuneBlaster } from 'equipment'
```

Then install this package, highlight the word `from` in any line, and click `cmd-alt-ctrl-]`.

## Disclaimer

This package was made due to the absence of this functionality in other alignment packages, has no tests, and has caused Atom to crash for 1 out of the 2 people who have tested this. Enjoy!
