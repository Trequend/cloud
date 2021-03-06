import MoreHorizIcon from '@mui/icons-material/MoreHoriz';
import { IconButton, IconButtonProps, Menu } from '@mui/material';
import { DeleteFolderMenuItem } from 'features/delete-folder';
import { DownloadFolderMenuItem } from 'features/download-folder';
import { RenameFolderMenuItem } from 'features/rename-folder';
import { FC, MouseEventHandler, useState } from 'react';

export type FolderActionsProps = {
  id: string;
  name: string;
} & Omit<IconButtonProps, 'onClick'>;

export const FolderActions: FC<FolderActionsProps> = ({ id, name, ...props }) => {
  const [anchorEl, setAnchorEl] = useState<HTMLButtonElement | null>(null);

  const handleClick: MouseEventHandler<HTMLButtonElement> = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const open = Boolean(anchorEl);

  return (
    <>
      <IconButton size="small" {...props} onClick={handleClick}>
        <MoreHorizIcon fontSize="small" />
      </IconButton>
      <Menu
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
        anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
        transformOrigin={{ vertical: 'top', horizontal: 'right' }}
        PaperProps={{ sx: { maxWidth: '150px', width: '100%' } }}
        MenuListProps={{ dense: true }}
      >
        <DownloadFolderMenuItem id={id} onDownload={handleClose} />
        <RenameFolderMenuItem id={id} name={name} onClose={handleClose} />
        <DeleteFolderMenuItem id={id} name={name} onDelete={handleClose} />
      </Menu>
    </>
  );
};
