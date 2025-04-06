import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Box,
  Tabs,
  Tab,
  Card,
  CardContent,
  CardMedia,
  Divider,
  TextField,
  Button,
  IconButton
} from '@material-ui/core';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Image as ImageIcon
} from '@material-ui/icons';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
  title: {
    marginBottom: theme.spacing(3),
  },
  tabsContainer: {
    marginBottom: theme.spacing(3),
  },
  card: {
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
    position: 'relative',
  },
  cardMedia: {
    paddingTop: '56.25%', // 16:9
    backgroundSize: 'cover',
    backgroundPosition: 'center',
  },
  cardContent: {
    flexGrow: 1,
  },
  cardActions: {
    display: 'flex',
    justifyContent: 'flex-end',
    padding: theme.spacing(1),
  },
  addButton: {
    marginTop: theme.spacing(2),
  },
  categoryTitle: {
    marginTop: theme.spacing(4),
    marginBottom: theme.spacing(2),
    position: 'relative',
    '&:after': {
      content: '""',
      position: 'absolute',
      bottom: -8,
      left: 0,
      width: 60,
      height: 4,
      backgroundColor: theme.palette.primary.main,
    },
  },
  visionQuote: {
    fontStyle: 'italic',
    color: theme.palette.text.secondary,
    marginBottom: theme.spacing(4),
    padding: theme.spacing(2),
    borderLeft: `4px solid ${theme.palette.primary.main}`,
    backgroundColor: theme.palette.background.default,
  },
  goalDescription: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(1),
  },
  goalDeadline: {
    color: theme.palette.text.secondary,
    fontSize: '0.875rem',
  },
  goalCategory: {
    position: 'absolute',
    top: theme.spacing(1),
    right: theme.spacing(1),
    backgroundColor: theme.palette.primary.main,
    color: theme.palette.primary.contrastText,
    padding: theme.spacing(0.5, 1),
    borderRadius: theme.spacing(1),
    fontSize: '0.75rem',
  },
  addCategoryButton: {
    marginBottom: theme.spacing(3),
  },
  divider: {
    margin: theme.spacing(4, 0),
  },
  visionBoard: {
    marginTop: theme.spacing(4),
  },
  visionBoardHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: theme.spacing(3),
  },
  visionImage: {
    height: 200,
    backgroundSize: 'cover',
    backgroundPosition: 'center',
    borderRadius: theme.shape.borderRadius,
    position: 'relative',
    cursor: 'pointer',
    '&:hover $visionImageOverlay': {
      opacity: 1,
    },
  },
  visionImageOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    opacity: 0,
    transition: 'opacity 0.3s ease',
    borderRadius: theme.shape.borderRadius,
  },
  visionImageActions: {
    display: 'flex',
  },
  visionImageActionButton: {
    color: 'white',
    margin: theme.spacing(0, 1),
  },
  categorySection: {
    marginBottom: theme.spacing(4),
  },
  categoryHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: theme.spacing(2),
  },
  visionText: {
    marginTop: theme.spacing(2),
    padding: theme.spacing(2),
    backgroundColor: theme.palette.background.default,
    borderRadius: theme.shape.borderRadius,
  },
}));

// Sample vision board categories
const categories = [
  { id: 1, name: 'Health & Fitness' },
  { id: 2, name: 'Intellectual Life' },
  { id: 3, name: 'Emotional Life' },
  { id: 4, name: 'Character' },
  { id: 5, name: 'Spiritual Life' },
  { id: 6, name: 'Love Relationship' },
  { id: 7, name: 'Parenting' },
  { id: 8, name: 'Social Life' },
  { id: 9, name: 'Financial' },
  { id: 10, name: 'Career' },
  { id: 11, name: 'Quality of Life' },
  { id: 12, name: 'Life Vision' },
];

// Sample vision board images
const visionImages = [
  { id: 1, category: 1, url: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Morning Run' },
  { id: 2, category: 9, url: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Financial Freedom' },
  { id: 3, category: 10, url: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Career Growth' },
  { id: 4, category: 11, url: 'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Dream Home' },
  { id: 5, category: 6, url: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Loving Relationship' },
  { id: 6, category: 2, url: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Continuous Learning' },
];

// Sample vision statements
const visionStatements = {
  1: 'I am in the best shape of my life, exercising regularly and eating nutritious foods that fuel my body. I have abundant energy and vitality.',
  2: 'I am constantly learning and growing intellectually. I read regularly, take courses, and engage in stimulating conversations.',
  3: 'I am emotionally balanced and resilient. I process my feelings in healthy ways and maintain a positive outlook on life.',
  4: 'I live with integrity and strong character. My actions align with my values, and I am known for my reliability and honesty.',
  5: 'I nurture my spiritual life through regular practices that connect me to something greater than myself.',
  6: 'I have a loving, supportive relationship built on mutual respect, trust, and shared values.',
  9: 'I am financially independent with multiple streams of income. I make wise investment decisions and live abundantly while being financially responsible.',
  10: 'I have a fulfilling career that utilizes my strengths and passions. I make a positive impact and am well-compensated for my contributions.',
  11: 'I live in a beautiful home that reflects my personality and provides comfort and inspiration. I travel regularly and enjoy life\'s pleasures.',
};

const Goals = () => {
  const classes = useStyles();
  const [tabValue, setTabValue] = useState(0);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  return (
    <div className={classes.root}>
      <Typography variant="h4" component="h1" className={classes.title}>
        My Goals & Vision Board
      </Typography>

      <Paper className={classes.tabsContainer}>
        <Tabs
          value={tabValue}
          onChange={handleTabChange}
          indicatorColor="primary"
          textColor="primary"
          centered
        >
          <Tab label="Vision Board" />
          <Tab label="Financial Goals" />
          <Tab label="Goal Timeline" />
        </Tabs>
      </Paper>

      {tabValue === 0 && (
        <div className={classes.visionBoard}>
          <Typography variant="h5" className={classes.visionBoardHeader}>
            My Life Vision
            <Button
              variant="contained"
              color="primary"
              startIcon={<AddIcon />}
              size="small"
            >
              Add Category
            </Button>
          </Typography>

          <Typography className={classes.visionQuote}>
            "Your Vision refers to the ideal state you would like to achieve in this important category. Ask yourself: How do you want this area of your life to feel? What do you want it to look like? What do you want to be doing on a consistent basis? Clearly describe your ideal Vision."
          </Typography>

          {categories.map((category) => (
            <div key={category.id} className={classes.categorySection}>
              <div className={classes.categoryHeader}>
                <Typography variant="h6" className={classes.categoryTitle}>
                  {category.name}
                </Typography>
                <Button
                  variant="outlined"
                  color="primary"
                  startIcon={<AddIcon />}
                  size="small"
                >
                  Add Image
                </Button>
              </div>

              {visionStatements[category.id] && (
                <Typography className={classes.visionText}>
                  {visionStatements[category.id]}
                </Typography>
              )}

              <Grid container spacing={3} style={{ marginTop: 16 }}>
                {visionImages
                  .filter((image) => image.category === category.id)
                  .map((image) => (
                    <Grid item xs={12} sm={6} md={4} key={image.id}>
                      <div
                        className={classes.visionImage}
                        style={{ backgroundImage: `url(${image.url})` }}
                      >
                        <div className={classes.visionImageOverlay}>
                          <div className={classes.visionImageActions}>
                            <IconButton className={classes.visionImageActionButton}>
                              <EditIcon />
                            </IconButton>
                            <IconButton className={classes.visionImageActionButton}>
                              <DeleteIcon />
                            </IconButton>
                          </div>
                        </div>
                      </div>
                      <Typography variant="subtitle1" align="center" style={{ marginTop: 8 }}>
                        {image.title}
                      </Typography>
                    </Grid>
                  ))}
              </Grid>
            </div>
          ))}
        </div>
      )}

      {tabValue === 1 && (
        <div>
          <div className={classes.categoryHeader}>
            <Typography variant="h5">
              This Year's Financial Goals
            </Typography>
            <Button
              variant="contained"
              color="primary"
              startIcon={<AddIcon />}
            >
              Add Goal
            </Button>
          </div>

          <Grid container spacing={3}>
            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Savings</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Emergency Fund"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Build 6-Month Emergency Fund
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Save $15,000 for emergency fund to cover 6 months of essential expenses.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2025
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={65} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">65%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>

            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Investment</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Investment"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Max Out Retirement Accounts
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Contribute maximum allowed amount to 401(k) and IRA accounts.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2025
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={40} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">40%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>

            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Debt</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Debt Free"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Pay Off Student Loans
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Completely pay off remaining $18,000 in student loan debt.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: June 30, 2025
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={75} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">75%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>
          </Grid>

          <Divider className={classes.divider} />

          <Typography variant="h5" className={classes.categoryTitle}>
            Long-Term Financial Goals
          </Typography>

          <Grid container spacing={3}>
            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Real Estate</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Home"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Buy Rental Property
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Purchase first rental property to generate passive income.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2027
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={25} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">25%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>

            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Financial Independence</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Financial Independence"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Achieve Financial Independence
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Build investment portfolio to generate $5,000 monthly passive income.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2035
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={15} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">15%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>
          </Grid>
        </div>
      )}

      {tabValue === 2 && (
        <div>
          <Typography variant="h5" gutterBottom>
            Goal Timeline
          </Typography>
          {/* Goal timeline content would go here */}
          <Typography variant="body1" color="textSecondary">
            Timeline visualization of your goals will be displayed here.
          </Typography>
        </div>
      )}
    </div>
  );
};

// Add missing LinearProgress component
const LinearProgress = ({ variant, value }) => {
  const getColor = (value) => {
    if (value < 30) return '#f44336';
    if (value < 70) return '#ff9800';
    return '#4caf50';
  };

  return (
    <div style={{ width: '100%', backgroundColor: '#e0e0e0', borderRadius: 5, height: 10 }}>
      <div
        style={{
          width: `${value}%`,
          backgroundColor: getColor(value),
          height: '100%',
          borderRadius: 5,
          transition: 'width 0.3s ease'
        }}
      />
    </div>
  );
};

export default Goals;
