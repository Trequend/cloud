import { alpha, Avatar, styled } from '@mui/material';
import { grey } from '@mui/material/colors';
import { FC, forwardRef, MouseEventHandler } from 'react';
import { useViewer } from '../hooks';

const ClickableAvatar = styled(Avatar)(() => ({
  position: 'relative',
  overflow: 'hidden',

  '&:after': {
    content: '""',
    position: 'absolute',
    width: '100%',
    height: '100%',
    background: '#00000000',
    transition: 'background 150ms ease-in',
  },

  '&:hover': {
    cursor: 'pointer',

    '&:after': {
      content: '""',
      position: 'absolute',
      width: '100%',
      height: '100%',
      background: alpha(grey[700], 0.4),
    },
  },
}));

export type ViewerAvatarProps = {
  onClick?: MouseEventHandler<HTMLDivElement>;
  width?: number;
  height?: number;
};

export const ViewerAvatar: FC<ViewerAvatarProps> = forwardRef<HTMLDivElement, ViewerAvatarProps>(
  ({ onClick, width, height }, ref) => {
    const viewer = useViewer();

    if (!viewer) {
      return null;
    }

    if (onClick) {
      return <ClickableAvatar ref={ref} onClick={onClick} {...stringAvatar(viewer.userName, width, height)} />;
    }

    return <Avatar ref={ref} {...stringAvatar(viewer.userName, width, height)} />;
  }
);

function stringAvatar(name: string, width?: number, height?: number) {
  return {
    sx: {
      bgcolor: 'primary.main',
      width: width ?? 36,
      height: height ?? 36,
    },
    children: `${name[0].toUpperCase()}`,
  };
}