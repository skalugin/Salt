base:
  '*':
    - presence

  'serverRole:database':
    - match: grain
    - 2-tier.database
    
  'serverRole:app':
    - match: grain
    - 2-tier.app
    
  'serverRole:postgres':
    - match: grain
    - PostgreSQL  
    
  'serverRole:camunda':
    - match: grain
    - Camunda
