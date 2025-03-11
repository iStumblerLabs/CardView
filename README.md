# CardView.framework

iStumbler Labs CardView.Framework — CardView is a good looking text view for iOS, macOS, 
and tvOS with convenience methods for formatting text, embedding controls and scaling content.

<a id="support"></a>
## Support CardView!

Are you using CardView in your apps? Would you like to help support the project and get a sponsor credit?

Visit our [Patreon Page](https://www.patreon.com/istumblerlabs) and patronize us in exchange for great rewards!


<a id="classes"></a>
## Classes

### [`CardTextView`](./Soruces/CardView/include/CardTextView.h)

Good looking subclasses of NSTextView & UITextView, with support for:

- Formatter Registry: Register NSFormatter subclasses to format text in a card
  with a single method call

- Column Styles: create `NSParagraphStyle`s with tabs for laying out columns
  in a card with a simple `NSArray<NSNumber*>*` describing the column widths

- Style Stack: maintain a stack of `NSParagraphStyle`s to allow a default style
  to be overidden while building a card and then restored to the previous state

- Promises: add a promise in the text while building your card, fulfill
  that promise later to allow generation of text in the background

- TODO: increaseSize/decreaseSize font actions

### [`CardFormatters`](./Sources/CardView/include/CardFormatters.h)

A collection of `NSFormatter` subclasses for formatting data:

#### CardArrayFormatter
formats Array values into comma separated lists

#### CardDataFormatter
formats data values into string with byte count: "420 Bytes"

#### CardStringDataFormatter
formats UTF data of any encoding into a string

#### CardListFormatter
formats arrays of objects with commas between the elements

#### CardURLFormatter
formats NSURLs as clickable links

#### CardPListDataFormatter
formats plist data

#### CardJSONObjectFormatter
formats a plist dictionary as JSON data

#### CardMarkdownFormatter
formats a plist dictionary as markdown text

#### CardDateFormatter
formats dates into the users preferred medium date and long time format

#### CardUnitsFormatter
formats number vales with units in grey text

#### CardBooleanFormatter
formats numeric values into boolean value strings: "Yes" or "No"

#### CardBytesFormatter
formats numbers as byte sizes

#### CardFractionFormatter
formats NSNumbers as a fractional value using the continued fraction method

#### CardTimecodeFormatter
display a time interval or duration in timecode format

Along with an `NSValueTransformer` subclass which wraps an `NSValueTransformer`

#### CardFormattingTransformer

## NSCells

### [`CardActionCell`](./Sources/CardView/include/CardActionCell.h)
<!-- TODO: review this for usage -->

An `NSCell` for displaying a button in a CardTextView on macOS

TODO: review usage and see if it's needed

### [`CardImageCell`](./Sources/CardView/include/CardImageCell.h)
<!-- TODO: review this for usage -->

An `NSCell` for displaying images in a CardTextView on macOS

### [`CardRuleCell`](./Sources/CardView/include/CardRuleCell.h)
<!-- TODO: review this for usage -->

An `NSCell` for displaying a separator line in a CardTextView

<a id="categories"></a>
## Categories

### [`NSMutableAttributedString+CardView`](./Sources/CardView/include/NSMutableAttributedString+CardView.h)

Implements `CardTextStyle` for `NSMutableAttributedString` to allow for building
of styled attributed strings for display in a TextView.

<a id="styles"></a>
## Styles

Styles are provided for formatting text:

```
typedef NS_ENUM(NSUInteger, CardTextStyle) {
    CardPlainStyle,
    CardHeaderStyle,
    CardSubheaderStyle,
    CardCenteredStyle,
    CardLabelStyle,
    CardGrayStyle,
    CardMonospaceStyle
};
```

<a id="Changes"></a>
## Changes

- TODO: 2.0 - 
    - breaking API changes: 
        - `CardTextView` is simplifed and tersified
        - `+formatted:withAttributes:` is now a class method
        - `CardSeperatorCell` -> `CardRuleCell`
        - remove `CardViewDelegate` inteface
    - adds `CardTextStyle` inteface for stying strings
    - adds `NSMutableAttributedString+CardView`
    - adds Promises and Style Stack to `CardTextView`
- 1.3 — 19 August 2024: Swift Package Manager Support
- 1.2 – 19 May 2017: 
- 1.1 — 29 May 2016: Add CardBytesFormatter
- 1.0.1 — 13 May 2016: Add CardListFormatter
- 1.0 — 27 April 2016: Initial Version

========

<a id="license"></a>
## License

    The MIT License (MIT)

    Copyright © 2014-2024 Alf Watt

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
