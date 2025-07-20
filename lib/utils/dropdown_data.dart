final Map<String, List<String>> stateCityMap = {
  // ----------------- STATES -----------------
  "Andhra Pradesh": [
    "Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Kurnool",
    "Tirupati", "Rajahmundry", "Kadapa", "Anantapur", "Eluru",
    "Ongole", "Chittoor", "Tenali", "Machilipatnam", "Srikakulam"
  ],
  "Arunachal Pradesh": [
    "Itanagar", "Naharlagun", "Pasighat", "Tawang", "Ziro",
    "Bomdila", "Roing", "Aalo", "Tezu", "Daporijo",
    "Seppa", "Khonsa", "Yingkiong", "Namsai", "Changlang"
  ],
  "Assam": [
    "Guwahati", "Silchar", "Dibrugarh", "Jorhat", "Nagaon",
    "Tinsukia", "Tezpur", "Bongaigaon", "Karimganj", "Goalpara",
    "Barpeta", "Diphu", "Sivasagar", "North Lakhimpur", "Dhubri"
  ],
  "Bihar": [
    "Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Darbhanga",
    "Purnia", "Hajipur", "Arrah", "Begusarai", "Katihar",
    "Munger", "Saharsa", "Motihari", "Samastipur", "Siwan"
  ],
  "Chhattisgarh": [
    "Raipur", "Bhilai", "Bilaspur", "Korba", "Rajnandgaon",
    "Durg", "Jagdalpur", "Ambikapur", "Raigarh", "Dhamtari",
    "Kanker", "Mahasamund", "Janjgir", "Kawardha", "Surajpur"
  ],
  "Goa": [
    "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda",
    "Bicholim", "Sanquelim", "Valpoi", "Curchorem", "Quepem"
  ],
  "Gujarat": [
    "Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar",
    "Jamnagar", "Junagadh", "Gandhinagar", "Anand", "Navsari",
    "Mehsana", "Bharuch", "Vapi", "Porbandar", "Morbi"
  ],
  "Haryana": [
    "Gurgaon", "Faridabad", "Panipat", "Ambala", "Hisar",
    "Karnal", "Rohtak", "Yamunanagar", "Sirsa", "Bahadurgarh",
    "Bhiwani", "Palwal", "Jind", "Kaithal", "Rewari"
  ],
  "Himachal Pradesh": [
    "Shimla", "Dharamshala", "Solan", "Mandi", "Kullu",
    "Bilaspur", "Chamba", "Una", "Nahan", "Hamirpur",
    "Kangra", "Sundernagar", "Palampur", "Paonta Sahib", "Karsog"
  ],
  "Jharkhand": [
    "Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Deoghar",
    "Hazaribagh", "Giridih", "Ramgarh", "Chaibasa", "Palamu",
    "Dumka", "Jamtara", "Sahibganj", "Latehar", "Godda"
  ],
  "Karnataka": [
    "Bengaluru", "Mysuru", "Mangaluru", "Hubballi", "Belagavi",
    "Davanagere", "Shivamogga", "Tumakuru", "Ballari", "Raichur",
    "Hassan", "Bidar", "Chikkamagaluru", "Kolar", "Udupi"
  ],
  "Kerala": [
    "Thiruvananthapuram", "Kochi", "Kozhikode", "Thrissur", "Kollam",
    "Kannur", "Alappuzha", "Palakkad", "Malappuram", "Pathanamthitta",
    "Idukki", "Kottayam", "Kasargod", "Wayanad", "Muvattupuzha"
  ],
  "Madhya Pradesh": [
    "Indore", "Bhopal", "Gwalior", "Jabalpur", "Ujjain",
    "Sagar", "Satna", "Ratlam", "Rewa", "Dewas",
    "Katni", "Chhindwara", "Vidisha", "Murwara", "Khandwa"
  ],
  "Maharashtra": [
    "Mumbai", "Pune", "Nagpur", "Nashik", "Aurangabad",
    "Thane", "Solapur", "Kolhapur", "Amravati", "Sangli",
    "Akola", "Jalgaon", "Latur", "Dhule", "Ahmednagar"
  ],
  "Manipur": [
    "Imphal", "Thoubal", "Bishnupur", "Churachandpur", "Kakching",
    "Ukhrul", "Senapati", "Tamenglong", "Jiribam", "Kangpokpi"
  ],
  "Meghalaya": [
    "Shillong", "Tura", "Nongstoin", "Jowai", "Baghmara",
    "Williamnagar", "Resubelpara", "Mairang", "Khliehriat", "Ampati"
  ],
  "Mizoram": [
    "Aizawl", "Lunglei", "Champhai", "Serchhip", "Kolasib",
    "Saiha", "Lawngtlai", "Mamit", "Bairabi", "Hnahthial"
  ],
  "Nagaland": [
    "Kohima", "Dimapur", "Mokokchung", "Tuensang", "Zunheboto",
    "Wokha", "Mon", "Phek", "Kiphire", "Longleng"
  ],
  "Odisha": [
    "Bhubaneswar", "Cuttack", "Rourkela", "Sambalpur", "Puri",
    "Berhampur", "Balasore", "Baripada", "Angul", "Bhadrak",
    "Jharsuguda", "Rayagada", "Kendrapara", "Koraput", "Jeypore"
  ],
  "Punjab": [
    "Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda",
    "Mohali", "Hoshiarpur", "Pathankot", "Moga", "Barnala",
    "Ferozepur", "Kapurthala", "Sangrur", "Ropar", "Muktsar"
  ],
  "Rajasthan": [
    "Jaipur", "Jodhpur", "Udaipur", "Kota", "Bikaner",
    "Ajmer", "Alwar", "Sikar", "Bhilwara", "Pali",
    "Hanumangarh", "Ganganagar", "Barmer", "Tonk", "Churu"
  ],
  "Sikkim": [
    "Gangtok", "Namchi", "Mangan", "Geyzing", "Rangpo",
    "Jorethang", "Singtam", "Ravangla", "Soreng", "Pakyong"
  ],
  "Tamil Nadu": [
    "Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem",
    "Erode", "Vellore", "Tirunelveli", "Thoothukudi", "Dindigul",
    "Cuddalore", "Thanjavur", "Nagercoil", "Karur", "Hosur"
  ],
  "Telangana": [
    "Hyderabad", "Warangal", "Nizamabad", "Karimnagar", "Khammam",
    "Nalgonda", "Ramagundam", "Adilabad", "Siddipet", "Mahbubnagar",
    "Mancherial", "Jagtial", "Bodhan", "Medak", "Suryapet"
  ],
  "Tripura": [
    "Agartala", "Udaipur", "Dharmanagar", "Kailasahar", "Ambassa",
    "Belonia", "Khowai", "Teliamura", "Sonamura", "Bishalgarh"
  ],
  "Uttar Pradesh": [
    "Lucknow", "Kanpur", "Varanasi", "Agra", "Meerut",
    "Ghaziabad", "Prayagraj", "Bareilly", "Aligarh", "Noida",
    "Moradabad", "Gorakhpur", "Jhansi", "Saharanpur", "Mathura"
  ],
  "Uttarakhand": [
    "Dehradun", "Haridwar", "Roorkee", "Haldwani", "Rudrapur",
    "Nainital", "Kashipur", "Pauri", "Pithoragarh", "Tehri"
  ],
  "West Bengal": [
    "Kolkata", "Asansol", "Siliguri", "Durgapur", "Howrah",
    "Kharagpur", "Haldia", "Berhampore", "Malda", "Bardhaman",
    "Raiganj", "Bally", "Serampore", "Chandannagar", "Naihati"
  ],

  // ----------------- UNION TERRITORIES -----------------
  "Andaman and Nicobar Islands": [
    "Port Blair", "Havelock Island", "Diglipur", "Neil Island", "Mayabunder"
  ],
  "Chandigarh": [
    "Chandigarh"
  ],
  "Dadra and Nagar Haveli and Daman and Diu": [
    "Silvassa", "Daman", "Diu"
  ],
  "Delhi": [
    "New Delhi", "Dwarka", "Rohini", "Lajpat Nagar", "Saket",
    "Pitampura", "Karol Bagh", "Mayur Vihar", "Janakpuri", "Hauz Khas",
    "Vasant Kunj", "Nehru Place", "Rajouri Garden", "Greater Kailash", "Chandni Chowk"
  ],
  "Jammu and Kashmir": [
    "Srinagar", "Jammu", "Anantnag", "Baramulla", "Udhampur",
    "Rajouri", "Kathua", "Pulwama", "Kupwara", "Kulgam"
  ],
  "Ladakh": [
    "Leh", "Kargil"
  ],
  "Lakshadweep": [
    "Kavaratti", "Agatti", "Minicoy", "Amini", "Kalpeni"
  ],
  "Puducherry": [
    "Puducherry", "Karaikal", "Mahe", "Yanam"
  ],
};


final List<String> industryOptions = [
  'Software & IT Services',
  'Design & Creative',
  'Finance & Accounting',
  'Education & Training',
  'Marketing & Advertising',
  'Writing & Editing',
  'Media & Entertainment',
  'Sales & Business Development',
  'Human Resources',
];



final Map<String, List<String>> fieldMap = {
  'Software & IT Services': [
    'Frontend Development',
    'Backend Development',
    'Full Stack Development',
    'DevOps & Cloud',
    'Data Science & AI',
    'Mobile App Development',
    'Software Testing',
  ],
  'Design & Creative': [
    'UI/UX Design',
    'Graphic Design',
    'Product Design',
    'Motion Graphics',
    'Brand Design',
    '3D Modeling',
  ],
  'Finance & Accounting': [
    'Accounting',
    'Auditing',
    'Investment Banking',
    'Financial Analysis',
    'Taxation',
    'FinTech',
  ],
  'Education & Training': [
    'Teaching',
    'EdTech',
    'Curriculum Design',
    'Training & Development',
    'Academic Research',
  ],
  'Marketing & Advertising': [
    'Digital Marketing',
    'Content Marketing',
    'SEO & SEM',
    'Brand Management',
    'Performance Marketing',
    'Market Research',
  ],
  'Writing & Editing': [
    'Content Writing',
    'Copywriting',
    'Technical Writing',
    'Proofreading',
    'Script Writing',
    'Editorial Management',
  ],
  'Media & Entertainment': [
    'Content Creation',
    'Video Editing',
    'Photography',
    'Journalism',
    'Animation & VFX',
    'Voice Over & Dubbing',
  ],
  'Sales & Business Development': [
    'Inside Sales',
    'Field Sales',
    'B2B Sales',
    'Business Strategy',
    'Lead Generation',
    'Client Relationship',
  ],
  'Human Resources': [
    'Recruitment',
    'Employee Relations',
    'HR Operations',
    'Learning & Development',
    'Payroll & Compliance',
    'Talent Management',
  ],
};


const Map<String, List<String>> skillsMap = {
  // Software & IT Services
  'Frontend Development': [
    'HTML', 'CSS', 'JavaScript', 'React', 'Angular', 'Vue.js', 'Tailwind CSS', 'Bootstrap', 'TypeScript', 'Responsive Design'
  ],
  'Backend Development': [
    'Node.js', 'Express.js', 'Django', 'Flask', 'Spring Boot', 'MySQL', 'MongoDB', 'GraphQL', 'REST APIs', 'API Security'
  ],
  'Full Stack Development': [
    'MERN Stack', 'MEAN Stack', 'Git', 'Docker', 'CI/CD', 'SQL', 'NoSQL', 'Agile', 'MVC Architecture', 'Version Control'
  ],
  'DevOps & Cloud': [
    'AWS', 'Azure', 'GCP', 'Docker', 'Kubernetes', 'Terraform', 'Jenkins', 'CI/CD', 'Linux Admin', 'Monitoring Tools'
  ],
  'Data Science & AI': [
    'Python', 'R', 'Pandas', 'NumPy', 'TensorFlow', 'Scikit-learn', 'Machine Learning', 'Deep Learning', 'Data Analysis', 'Statistics'
  ],
  'Mobile App Development': [
    'Flutter', 'React Native', 'Android (Java/Kotlin)', 'iOS (Swift)', 'Firebase', 'Dart', 'App Store Deployment', 'Push Notifications', 'UI Design', 'SQLite'
  ],
  'Software Testing': [
    'Manual Testing', 'Automation Testing', 'Selenium', 'JUnit', 'TestNG', 'Bug Tracking', 'API Testing', 'Performance Testing', 'Load Testing', 'Postman'
  ],

  // Design & Creative
  'UI/UX Design': [
    'Figma', 'Sketch', 'Adobe XD', 'Prototyping', 'Wireframing', 'User Research', 'Interaction Design', 'Design Systems', 'Usability Testing', 'Responsive Design'
  ],
  'Graphic Design': [
    'Adobe Photoshop', 'Illustrator', 'InDesign', 'Typography', 'Color Theory', 'Layout Design', 'Canva', 'Branding', 'Print Design', 'Mockups'
  ],
  'Product Design': [
    'Design Thinking', 'UX Research', 'Prototyping', 'Journey Mapping', 'Figma', 'Feature Design', 'Design Systems', 'Sketching', 'Accessibility Design', 'Wireflows'
  ],
  'Motion Graphics': [
    'After Effects', 'Premiere Pro', '2D/3D Animation', 'Storyboarding', 'Sound Design', 'Typography Animation', 'Illustration', 'Keyframing', 'Transitions', 'Compositing'
  ],
  'Brand Design': [
    'Logo Design', 'Visual Identity', 'Typography', 'Color Palettes', 'Brand Guidelines', 'Mood Boards', 'Consistency', 'Rebranding', 'Brand Strategy', 'Packaging Design'
  ],
  '3D Modeling': [
    'Blender', '3ds Max', 'Cinema 4D', 'ZBrush', 'UV Mapping', 'Texturing', 'Lighting', 'Rendering', 'Rigging', 'Animation Basics'
  ],

  // Finance & Accounting
  'Accounting': [
    'Tally', 'QuickBooks', 'Bookkeeping', 'Financial Statements', 'Ledger Management', 'Accounts Payable', 'Accounts Receivable', 'Reconciliation', 'Journal Entries', 'ERP'
  ],
  'Auditing': [
    'Audit Planning', 'Internal Audit', 'External Audit', 'Compliance', 'Risk Assessment', 'Audit Tools', 'Documentation', 'IFRS', 'GAAP', 'Working Papers'
  ],
  'Investment Banking': [
    'Financial Modeling', 'Valuation', 'M&A', 'IPO Process', 'Pitch Decks', 'DCF', 'Equity Research', 'Capital Markets', 'Excel', 'Presentation Skills'
  ],
  'Financial Analysis': [
    'Ratio Analysis', 'Forecasting', 'Budgeting', 'Excel Modeling', 'Power BI', 'Dashboarding', 'Variance Analysis', 'KPI Tracking', 'Data Interpretation', 'Reporting'
  ],
  'Taxation': [
    'Income Tax', 'GST', 'TDS', 'ITR Filing', 'Corporate Tax', 'Compliance', 'Tax Planning', 'Tax Computation', 'Audit Under Tax', 'Wealth Tax'
  ],
  'FinTech': [
    'Blockchain Basics', 'Crypto Knowledge', 'RPA', 'FinTech Products', 'Digital Payments', 'NFC', 'Data Privacy', 'Regulatory Tech', 'UI/UX for Finance', 'Security Compliance'
  ],

  // Education & Training
  'Teaching': [
    'Lesson Planning', 'Subject Expertise', 'CBSE/ICSE Curriculum', 'Smart Classroom Tools', 'Communication Skills', 'Assessment', 'Google Classroom', 'Zoom', 'Mentoring', 'Behavior Management'
  ],
  'EdTech': [
    'Moodle', 'Kahoot', 'Canvas LMS', 'Interactive Tools', 'Gamification', 'Virtual Whiteboard', 'Video Content', 'E-learning', 'SCORM', 'Tech Integration'
  ],
  'Curriculum Design': [
    'Instructional Design', 'Learning Outcomes', 'Bloom’s Taxonomy', 'Academic Structuring', 'Rubrics', 'Course Mapping', 'Evaluation Design', 'Subject Planning', 'E-content', 'Outcome Assessment'
  ],
  'Training & Development': [
    'L&D Programs', 'Soft Skills Training', 'Onboarding Training', 'Workshop Planning', 'Corporate Training', 'LMS Tools', 'Feedback Evaluation', 'Skill Gap Analysis', 'Virtual Training', 'Learning Analytics'
  ],
  'Academic Research': [
    'Research Methodologies', 'Literature Review', 'Data Collection', 'Thesis Writing', 'SPSS', 'Research Ethics', 'Publication', 'Survey Design', 'Statistical Tools', 'Referencing Styles'
  ],

  // Marketing & Advertising
  'Digital Marketing': [
    'SEO', 'SEM', 'Google Ads', 'Facebook Ads', 'Email Marketing', 'Analytics', 'Conversion Optimization', 'Retargeting', 'Funnels', 'A/B Testing'
  ],
  'Content Marketing': [
    'Blog Writing', 'Strategy', 'Content Calendar', 'Ebooks', 'Whitepapers', 'Infographics', 'Case Studies', 'SEO Tools', 'Copywriting', 'Content Distribution'
  ],
  'SEO & SEM': [
    'Keyword Research', 'On-page SEO', 'Off-page SEO', 'Google Search Console', 'Google Analytics', 'Meta Tags', 'Link Building', 'SEM Tools', 'Crawling', 'Indexing'
  ],
  'Brand Management': [
    'Brand Identity', 'Storytelling', 'Brand Voice', 'Visual Branding', 'Campaign Management', 'Positioning', 'Market Perception', 'Customer Insights', 'Taglines', 'Strategy Decks'
  ],
  'Performance Marketing': [
    'CPC/CPM', 'Campaign Analytics', 'Budgeting', 'ROI Calculation', 'A/B Testing', 'Facebook Pixel', 'Google Tag Manager', 'Lead Tracking', 'Conversion Goals', 'Media Planning'
  ],
  'Market Research': [
    'Survey Design', 'Competitor Analysis', 'SWOT', 'Trend Analysis', 'User Research', 'Data Interpretation', 'Target Segmentation', 'Customer Personas', 'Focus Groups', 'Reports'
  ],

  // Writing & Editing
  'Content Writing': [
    'SEO Writing', 'Blogging', 'Copywriting', 'Research', 'Grammar', 'WordPress', 'Plagiarism Tools', 'Content Strategy', 'Editing', 'Storytelling'
  ],
  'Copywriting': [
    'Headlines', 'Landing Pages', 'CTAs', 'Sales Copy', 'Email Copy', 'Product Descriptions', 'Brand Voice', 'Persuasion', 'UX Writing', 'Scripting'
  ],
  'Technical Writing': [
    'API Docs', 'User Manuals', 'Whitepapers', 'Process Docs', 'Diagrams', 'Markdown', 'Version Control', 'Technical Diagrams', 'Editor Tools', 'Documentation Standards'
  ],
  'Proofreading': [
    'Grammar Checking', 'Punctuation', 'Fact-checking', 'Style Guide', 'Spelling', 'Consistency', 'Typos', 'Clarity', 'Conciseness', 'Track Changes'
  ],
  'Script Writing': [
    'Structure', 'Dialogue', 'Screenwriting', 'Monologues', 'Screenplay Format', 'Plot Development', 'Genre Knowledge', 'Voiceover Writing', 'Storyboarding', 'Character Arcs'
  ],
  'Editorial Management': [
    'Content Planning', 'Team Management', 'Review Process', 'Publishing Schedule', 'Feedback Handling', 'SEO Oversight', 'Topic Selection', 'Proofing', 'Communication', 'Workflow Tools'
  ],

  // Media & Entertainment
  'Content Creation': [
    'Reels', 'YouTube', 'Instagram', 'TikTok', 'Short-form Video', 'Creative Direction', 'Content Strategy', 'Editing Tools', 'Trends Analysis', 'Scripting'
  ],
  'Video Editing': [
    'Premiere Pro', 'After Effects', 'Color Correction', 'Sound Mixing', 'Transitions', 'Export Settings', 'Storyboarding', 'Timeline Management', 'Captioning', 'Motion Graphics'
  ],
  'Photography': [
    'DSLR Use', 'Lighting Techniques', 'Portraits', 'Product Photography', 'Editing (Lightroom)', 'Composition', 'Camera Settings', 'Lens Knowledge', 'Retouching', 'Studio Setup'
  ],
  'Journalism': [
    'Reporting', 'Investigative Skills', 'Interviewing', 'Editing', 'Media Ethics', 'News Writing', 'Story Development', 'Publishing Tools', 'Live Coverage', 'Fact Checking'
  ],
  'Animation & VFX': [
    'Maya', 'Blender', 'After Effects', 'Character Animation', 'Compositing', 'Green Screen', 'Rotoscoping', 'Texturing', 'Rigging', 'Rendering'
  ],
  'Voice Over & Dubbing': [
    'Voice Modulation', 'Script Reading', 'Recording Equipment', 'Audio Editing', 'Language Fluency', 'Expression Delivery', 'Background Score', 'Noise Reduction', 'Breath Control', 'Tone Matching'
  ],

  // Sales & Business Development
  'Inside Sales': [
    'Cold Calling', 'CRM Tools', 'Email Outreach', 'Lead Nurturing', 'Product Pitching', 'Demo Scheduling', 'Objection Handling', 'Pipeline Management', 'Quota Achievement', 'Follow-ups'
  ],
  'Field Sales': [
    'Client Interaction', 'Territory Planning', 'Face-to-face Sales', 'Lead Generation', 'Product Demos', 'Travel Management', 'Reporting', 'Closing Deals', 'Target Achievement', 'POS Tools'
  ],
  'B2B Sales': [
    'Client Prospecting', 'Presentation Skills', 'Negotiation', 'Sales Enablement', 'Contract Management', 'Lead Scoring', 'CRM Usage', 'Follow-ups', 'Proposal Creation', 'Revenue Forecasting'
  ],
  'Business Strategy': [
    'Market Research', 'Growth Hacking', 'Business Modeling', 'Competitor Analysis', 'SWOT', 'Pitch Decks', 'Unit Economics', 'Strategic Planning', 'Expansion Planning', 'Partnerships'
  ],
  'Lead Generation': [
    'Lead Lists', 'Cold Outreach', 'LinkedIn Sales', 'Email Finder Tools', 'Prospecting', 'Qualifying Leads', 'CRM Input', 'Drip Campaigns', 'Conversion Funnels', 'Inbound Marketing'
  ],
  'Client Relationship': [
    'Account Management', 'Renewals', 'Upselling', 'Customer Success', 'Conflict Resolution', 'Service Delivery', 'Client Feedback', 'Satisfaction Metrics', 'Escalation Handling', 'Support Tools'
  ],

  // Human Resources
  'Recruitment': [
    'Job Posting', 'Screening', 'Interviewing', 'ATS Tools', 'Campus Hiring', 'Referral Programs', 'Offer Rollout', 'Job Description Writing', 'Follow-ups', 'Onboarding'
  ],
  'Employee Relations': [
    'Conflict Resolution', 'Communication', 'Grievance Redressal', 'Policy Enforcement', 'Workplace Culture', 'Feedback Systems', 'Exit Interviews', 'Engagement Programs', 'Wellness', 'HRBP Support'
  ],
  'HR Operations': [
    'Attendance Systems', 'Leave Management', 'Compliance', 'HRMS Tools', 'Employee Data', 'Payroll Integration', 'Policy Documentation', 'Exit Process', 'Queries Handling', 'Reports'
  ],
  'Learning & Development': [
    'Training Calendar', 'Skill Development', 'LMS Platforms', 'Learning Content', 'TNA', 'Feedback Tools', 'Virtual Training', 'Soft Skills', 'Mentoring Programs', 'E-learning Design'
  ],
  'Payroll & Compliance': [
    'Payroll Processing', 'Statutory Compliance', 'ESIC', 'PF', 'Salary Slips', 'TDS', 'Labor Laws', 'Reimbursements', 'Attendance Integration', 'Audits'
  ],
  'Talent Management': [
    'Succession Planning', 'HiPo Programs', 'Performance Reviews', 'Career Pathing', 'Retention Strategy', 'Competency Mapping', 'HR Analytics', 'Development Plans', 'Rewards System', 'Appraisal Process'
  ],
};

// Existing industryOptions, fieldMap, skillsMap remain as you already have

// Add this part for Master Keywords
List<String> masterKeywordList = [
  'Flutter',
  'Dart',
  'Firebase',
  'Backend',
  'Frontend',
  'UI/UX',
  'NodeJS',
  'Python',
  'Java',
  'SQL',
  'Machine Learning',
  'Data Science',
];

// Add this part for Master Locations
List<String> masterLocationList = [
  'Ahmedabad, Gujarat',
  'Mumbai, Maharashtra',
  'Pune, Maharashtra',
  'Bangalore, Karnataka',
  'Hyderabad, Telangana',
  'Chennai, Tamil Nadu',
  'Delhi, Delhi',
  'Kolkata, West Bengal',
  'Jaipur, Rajasthan',
  'Indore, Madhya Pradesh',
];

final List<String> degreeOptions = [
  'B.Tech',
  'M.Tech',
  'B.Sc',
  'M.Sc',
  'BBA',
  'MBA',
  'B.Com',
  'M.Com',
  'BA',
  'MA',
  'Diploma',
  'Ph.D',
  'Other',
];

final Map<String, List<String>> specializationMap = {
  'B.Tech': ['CSE', 'IT', 'ECE', 'EEE', 'Mechanical', 'Civil', 'Biotech'],
  'M.Tech': ['CSE', 'AI/ML', 'Data Science', 'Mechanical', 'VLSI', 'Power Systems'],
  'B.Sc': ['Computer Science', 'Maths', 'Physics', 'Chemistry', 'Biotechnology'],
  'M.Sc': ['Data Science', 'Statistics', 'Physics', 'Maths', 'Life Sciences'],
  'BBA': ['Finance', 'Marketing', 'HR', 'Operations', 'International Business'],
  'MBA': ['Finance', 'Marketing', 'HR', 'Operations', 'IT', 'Entrepreneurship'],
  'B.Com': ['General', 'Honours', 'Accounting', 'Finance', 'Taxation'],
  'M.Com': ['Accounting', 'Taxation', 'Economics', 'Finance'],
  'BA': ['English', 'Psychology', 'Sociology', 'Political Science'],
  'MA': ['English', 'Psychology', 'Sociology', 'Public Administration'],
  'Diploma': ['Computer', 'Mechanical', 'Electrical', 'Civil', 'ECE'],
  'Ph.D': ['Engineering', 'Sciences', 'Management', 'Humanities'],
  'Other': ['General'],
};