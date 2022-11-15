import { WebPlugin } from '@capacitor/core';

import type { ChooserData, FileChooserPlugin } from './definitions';

export class FileChooserWeb extends WebPlugin implements FileChooserPlugin {
  getFiles(accept?: string): Promise<ChooserData> {
    console.log(accept);
    return Promise.resolve({

    } as ChooserData);
  }
}
