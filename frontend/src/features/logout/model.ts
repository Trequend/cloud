import { viewerModel } from 'entities/viewer';
import { cloudApi } from 'shared/api';
import { cloudHelpers } from 'shared/helpers';
import { Action } from 'shared/types';

export const logoutAction: Action<void, string> = {
  execute: async () => {
    await cloudApi.auth.logout();
    viewerModel.setUnauthorized();
  },
  errorPayloadExtractor: cloudHelpers.getErrorMessage,
};
