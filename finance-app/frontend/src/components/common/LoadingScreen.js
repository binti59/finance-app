import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import { CircularProgress, Box, Typography } from '@material-ui/core';

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100vh',
    backgroundColor: theme.palette.background.default,
  },
  title: {
    marginTop: theme.spacing(2),
    color: theme.palette.primary.main,
  },
}));

const LoadingScreen = () => {
  const classes = useStyles();

  return (
    <Box className={classes.root}>
      <CircularProgress size={60} thickness={4} />
      <Typography variant="h6" className={classes.title}>
        Loading Finance Manager...
      </Typography>
    </Box>
  );
};

export default LoadingScreen;
