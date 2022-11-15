export interface FileChooserPlugin {
  getFiles(accept?: string): Promise<ChooserData>;
}

export interface ChooserData {
  data: ChooserFile[];
  message: string;
  code: string;
}

export interface ChooserFile {
  mediaType: string;
  name: string;
  uri: string;
  size: number;
}
