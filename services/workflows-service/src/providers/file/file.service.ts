import {
  TLocalFilePath,
  TRemoteFileConfig,
  TFileServiceProvider,
  IStreamableFileProvider,
} from './types';
import * as tmp from 'tmp';
import { Injectable } from '@nestjs/common';

@Injectable()
export class FileService {
  async copyFileFromSourceToDestination(
    fromServiceProvider: TFileServiceProvider,
    fromRemoteFileConfig: TRemoteFileConfig,
    toServiceProvider: TFileServiceProvider,
    toFileConfig: TRemoteFileConfig,
  ) {
    if (this.isBothServicesSupportStream(fromServiceProvider, toServiceProvider)) {
      return this.copyThruStream(
        fromServiceProvider as IStreamableFileProvider,
        fromRemoteFileConfig,
        toServiceProvider as IStreamableFileProvider,
        toFileConfig,
      );
    }

    return await this.copyThruLocalFile(
      fromServiceProvider,
      fromRemoteFileConfig,
      toServiceProvider,
      toFileConfig,
    );
  }

  async copyThruStream(
    fromServiceProvider: IStreamableFileProvider,
    fromRemoteFileConfig: TRemoteFileConfig,
    toServiceProvider: IStreamableFileProvider,
    toFileConfig: TRemoteFileConfig,
  ) {
    const streamableDownstream = await fromServiceProvider.fetchRemoteFileDownStream(
      fromRemoteFileConfig,
    );

    return await toServiceProvider.uploadFileStream(streamableDownstream, toFileConfig);
  }

  async copyThruLocalFile(
    fromServiceProvider: TFileServiceProvider,
    fromRemoteFileConfig: TRemoteFileConfig,
    toServiceProvider: TFileServiceProvider,
    toFileConfig: TRemoteFileConfig,
  ) {
    const tmpFile = tmp.fileSync();

    const localeFilePath = await fromServiceProvider.downloadFile(
      fromRemoteFileConfig,
      tmpFile.name,
    );
    const remoteFilePath = await toServiceProvider.uploadFile(localeFilePath, toFileConfig);

    return remoteFilePath;
  }

  async downloadFile(
    fromServiceProvider: TFileServiceProvider,
    fromRemoteFileConfig: TRemoteFileConfig,
    toLocaleFilePath: TLocalFilePath,
  ) {
    return await fromServiceProvider.downloadFile(fromRemoteFileConfig, toLocaleFilePath);
  }

  private isBothServicesSupportStream(
    fromServiceProvider: TFileServiceProvider,
    toServiceProvider: TFileServiceProvider,
  ) {
    return (
      'fetchRemoteFileDownStream' in fromServiceProvider && 'uploadFileStream' in toServiceProvider
    );
  }
}