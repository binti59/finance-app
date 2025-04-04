# Enhanced Personal Finance Management System - Documentation

## Overview

The Enhanced Personal Finance Management System is a comprehensive web application designed to help users track, analyze, and optimize their financial health. This document provides detailed information about the new features and how to use them.

## New Features

### 1. Multi-source Data Integration

The system now supports connecting to multiple financial data sources:

- **Direct API Connections**: Connect directly to HSBC, Trading212, and Moneybox
- **CSV/PDF Statement Upload**: Upload and parse bank statements and investment data
- **Manual Data Entry**: Add transactions and accounts manually

#### How to Use:
1. Navigate to the "Connections" page
2. Click "Add New Connection"
3. Select your financial institution or upload method
4. Follow the authentication steps or file upload process
5. Your data will be automatically categorized and integrated into your dashboard

### 2. Comprehensive Financial Dashboard

The enhanced dashboard provides a holistic view of your financial status:

- **Net Worth Tracking**: View your total assets minus liabilities
- **Income and Expense Analysis**: Visualize your cash flow with detailed breakdowns
- **Cash Flow Visualization**: See how money moves through your accounts
- **Asset Allocation Overview**: Understand how your wealth is distributed

#### How to Use:
1. The dashboard is your home page after logging in
2. Use the date filters to view different time periods
3. Hover over charts for detailed information
4. Click on any section to drill down into more detailed views

### 3. Advanced Financial KPIs

Track key performance indicators for your financial health:

- **Financial Independence Index**: Measure your progress toward financial freedom
- **Financial Freedom Number**: Calculate how much you need to be financially independent
- **Savings Rate Tracking**: Monitor what percentage of income you're saving
- **Financial Health Score**: Get an overall rating of your financial situation

#### How to Use:
1. Navigate to the "KPIs" section of your dashboard
2. Set your financial goals and targets
3. The system will automatically calculate your KPIs based on your data
4. Use the insights to make informed financial decisions

### 4. Investment Portfolio Management

Comprehensive tools for managing your investments:

- **Asset Performance Tracking**: Monitor how your investments are performing
- **Portfolio Diversification Analysis**: Ensure your investments are properly diversified
- **Return on Investment Calculations**: See your actual returns across different time periods

#### How to Use:
1. Go to the "Investments" page
2. View your portfolio allocation and performance
3. Use the analysis tools to identify opportunities for optimization
4. Set investment goals and track your progress

### 5. Financial Independence Planning

Tools to help you achieve financial freedom:

- **Financial Independence Calculator**: Determine when you can achieve financial independence
- **Retirement Planning**: Plan for a comfortable retirement
- **Goal Setting and Tracking**: Set financial goals and monitor your progress

#### How to Use:
1. Navigate to the "Planning" section and select "Financial Independence"
2. Enter your current financial information and goals
3. Adjust parameters like withdrawal rate and expected returns
4. View projections and recommendations for achieving your goals

## Installation Instructions

### Enhanced Installation

Use the enhanced installation script for a complete setup:

```bash
sudo ./install_finance_app_enhanced.sh
```

This script will:
1. Install all required dependencies
2. Set up the database with the enhanced schema
3. Configure the application with default settings
4. Start all services

### Testing

To verify that all features are working correctly:

```bash
./test.sh
```

This script will test all major components of the system and report any issues.

### Uninstallation

If you need to remove the application:

```bash
sudo ./uninstall_finance_app_enhanced.sh
```

This script will:
1. Stop all services
2. Remove all application files
3. Optionally create a final backup of your data

## System Requirements

- Ubuntu 20.04 or newer
- Docker and Docker Compose
- 4GB RAM minimum (8GB recommended)
- 20GB free disk space
- Internet connection for API integrations

## Troubleshooting

### Common Issues

1. **Connection Errors**:
   - Check your internet connection
   - Verify API credentials in the .env file
   - Ensure firewall allows required connections

2. **Database Issues**:
   - Check PostgreSQL logs: `docker-compose logs postgres`
   - Verify database credentials in the .env file
   - Ensure database port is not in use by another application

3. **Frontend Not Loading**:
   - Check browser console for errors
   - Verify frontend container is running: `docker-compose ps`
   - Check frontend logs: `docker-compose logs frontend`

### Management Script

Use the enhanced management script for common tasks:

```bash
finance-manage [command]
```

Available commands:
- `status`: Check the status of all services
- `logs [service]`: View logs for a specific service
- `restart`: Restart all services
- `backup`: Create a manual backup
- `restore [file]`: Restore from a backup file
- `health`: Run a health check on the system

## Security Considerations

- All API keys are stored encrypted in the database
- JWT authentication is used for all API requests
- HTTPS is configured by default for secure communication
- Regular backups are scheduled automatically

## Data Privacy

- All financial data is stored locally on your server
- No data is sent to external services without your consent
- You can export or delete your data at any time from the Settings page

## Support and Feedback

If you encounter any issues or have suggestions for improvements, please:
1. Check the troubleshooting section above
2. Review the logs using `finance-manage logs`
3. Create an issue on the GitHub repository with detailed information

## Future Enhancements

We're planning to add the following features in future updates:
- Additional financial institution integrations
- Mobile application
- AI-powered financial insights and recommendations
- Budgeting automation
- Tax optimization suggestions

Thank you for using the Enhanced Personal Finance Management System!
