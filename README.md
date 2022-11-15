# Simple file chooser

use https://github.com/hinddeep/capacitor-file-selector

## Install

```bash
npm install @innoline/capacitor-file-chooser
npx cap sync
```

## API

<docgen-index>

* [`getFiles(...)`](#getfiles)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### getFiles(...)

```typescript
getFiles(accept?: string | undefined) => Promise<ChooserData>
```

| Param        | Type                |
| ------------ | ------------------- |
| **`accept`** | <code>string</code> |

**Returns:** <code>Promise&lt;<a href="#chooserdata">ChooserData</a>&gt;</code>

--------------------


### Interfaces


#### ChooserData

| Prop          | Type                       |
| ------------- | -------------------------- |
| **`data`**    | <code>ChooserFile[]</code> |
| **`message`** | <code>string</code>        |
| **`code`**    | <code>string</code>        |


#### ChooserFile

| Prop            | Type                |
| --------------- | ------------------- |
| **`mediaType`** | <code>string</code> |
| **`name`**      | <code>string</code> |
| **`uri`**       | <code>string</code> |
| **`size`**      | <code>number</code> |

</docgen-api>
