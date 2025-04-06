const initialState = {
  goals: [
    {
      id: 1,
      name: 'Build 6-Month Emergency Fund',
      category: 'Savings',
      target_amount: 15000,
      current_amount: 9750,
      deadline: '2025-12-31',
      priority: 1,
      status: 'active'
    },
    {
      id: 2,
      name: 'Max Out Retirement Accounts',
      category: 'Investment',
      target_amount: 20500,
      current_amount: 8200,
      deadline: '2025-12-31',
      priority: 2,
      status: 'active'
    },
    {
      id: 3,
      name: 'Pay Off Student Loans',
      category: 'Debt',
      target_amount: 18000,
      current_amount: 13500,
      deadline: '2025-06-30',
      priority: 3,
      status: 'active'
    }
  ],
  recommendations: {
    recommendations: [
      {
        id: 1,
        title: 'Increase Emergency Fund',
        description: 'Based on your spending patterns, we recommend increasing your emergency fund target to cover 8 months of expenses.',
        impact: 'high'
      },
      {
        id: 2,
        title: 'Start Investing in Index Funds',
        description: 'Consider allocating a portion of your savings to low-cost index funds for long-term growth.',
        impact: 'medium'
      },
      {
        id: 3,
        title: 'Refinance Student Loans',
        description: 'Current interest rates are lower than your student loan rate. Consider refinancing to save on interest.',
        impact: 'medium'
      }
    ]
  },
  loading: false,
  error: null
};

export default function(state = initialState, action) {
  const { type, payload } = action;
  
  switch (type) {
    case 'GET_GOALS':
      return {
        ...state,
        goals: payload,
        loading: false
      };
    case 'GET_GOAL_RECOMMENDATIONS':
      return {
        ...state,
        recommendations: payload,
        loading: false
      };
    case 'ADD_GOAL':
      return {
        ...state,
        goals: [...state.goals, payload],
        loading: false
      };
    case 'UPDATE_GOAL':
      return {
        ...state,
        goals: state.goals.map(goal => 
          goal.id === payload.id ? payload : goal
        ),
        loading: false
      };
    case 'DELETE_GOAL':
      return {
        ...state,
        goals: state.goals.filter(goal => goal.id !== payload),
        loading: false
      };
    case 'GOAL_ERROR':
      return {
        ...state,
        error: payload,
        loading: false
      };
    default:
      return state;
  }
}
