/// Guide data model for storing guide content
class Guide {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<GuideSection> sections;

  const Guide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.sections,
  });
}

class GuideSection {
  final String heading;
  final String content;

  const GuideSection({
    required this.heading,
    required this.content,
  });
}

/// All guides data
final List<Guide> allGuides = [
  Guide(
    id: 'focus-foods',
    title: 'Foods to Fuel Your Focus and Power Up Your Productivity',
    subtitle: 'How the right foods can outperform coffee for lasting energy and mental clarity',
    emoji: '🧠',
    sections: [
      const GuideSection(
        heading: '',
        content: 'Many people rely on coffee to stay sharp, but while caffeine can provide a short-term boost, nutrition plays a far bigger role in sustained focus and productivity. Your brain requires steady fuel to function at its best — and the foods you choose directly impact your energy, concentration, and mood.\n\nThis guide outlines simple, effective nutrition strategies to help you stay alert, productive, and mentally strong throughout the day.',
      ),
      const GuideSection(
        heading: 'WHY NUTRITION MATTERS FOR FOCUS',
        content: 'Your brain is one of the most energy-demanding organs in your body. It primarily runs on glucose, and when you haven\'t eaten enough, your body releases hunger signals that make concentration difficult.\n\nHowever, not all foods provide stable energy. Some cause rapid spikes and crashes, leaving you tired and unfocused — while others deliver consistent fuel that keeps your mind sharp.',
      ),
      const GuideSection(
        heading: 'FOCUS-BOOSTING NUTRITION BUILDING BLOCKS',
        content: '**Prioritize Protein**\nProtein provides longer-lasting energy compared to refined carbohydrates and helps prevent mid-morning or afternoon crashes. It also supports muscle health and keeps you feeling full longer.\n\n• Chicken\n• Tuna\n• Eggs\n• Beans and lentils\n• Cheese and yogurt\n• Nuts\n• Tofu\n\n**Choose Antioxidant-Rich Foods**\nAntioxidants help protect brain cells from damage and support overall brain health.\n\n• Avocado\n• Berries\n• Leafy greens\n• Extra virgin olive oil\n• Dark chocolate\n\n**Increase Fibre Intake**\nFibre slows the release of sugar into your bloodstream, helping maintain stable energy.\n\n• Legumes\n• Nuts and seeds\n• Whole grains\n• Fruits\n• Vegetables\n\n**Stay Properly Hydrated**\nEven mild dehydration can impair brain function and reduce alertness. Aim for roughly 3 litres of fluids per day for men, adjusting based on activity level and climate.',
      ),
      const GuideSection(
        heading: 'FOOD HABITS THAT SUPPORT ATTENTION',
        content: '**Eat Consistently**\nGoing too long without eating can lead to energy dips and mood changes. Eating approximately every 4 hours helps maintain steady mental performance.\n\n**Don\'t Skip Meals**\nSkipping meals — especially lunch — often backfires. Low blood sugar can increase stress, anxiety, and difficulty concentrating.\n\n**Limit Refined Carbohydrates**\nFrequent intake of foods like cookies, crackers, and white bread can destabilize blood sugar, making focus harder to maintain.',
      ),
      const GuideSection(
        heading: 'NUTRITION AND ADHD',
        content: 'For individuals with attention challenges, meal timing and protein intake become even more important.\n\nProtein helps your body produce neurotransmitters that support alertness and sustained energy. It may also reduce rapid blood sugar fluctuations that can contribute to impulsivity and hyperactivity.',
      ),
      const GuideSection(
        heading: 'SIMPLE MEAL IDEAS FOR BETTER FOCUS',
        content: '• Omelette with vegetables\n• Steel-cut oats with berries and nuts\n• Greek yogurt with seeds and banana\n• Tuna melt on whole grain bread with vegetables\n• Turkey and bean chili\n• Whole wheat wrap with chicken, hummus, cheese, and veggies',
      ),
      const GuideSection(
        heading: 'CONCLUSION',
        content: 'If you find yourself struggling with concentration, don\'t immediately reach for another cup of coffee. Instead, pause and refuel with nutrient-dense foods that provide steady energy.\n\nWhen you nourish your body properly, your brain performs better — helping you stay productive, clear-headed, and ready to take on the day.',
      ),
    ],
  ),

  Guide(
    id: 'healthy-snacking',
    title: 'Healthy Snacking 101: Smart Choices Between Meals',
    subtitle: 'How to snack in a way that controls hunger, supports energy, and prevents overeating',
    emoji: '🍎',
    sections: [
      const GuideSection(
        heading: '',
        content: 'Hunger doesn\'t always wait for your next meal. A well-timed snack can stabilize energy, improve focus, and prevent excessive eating later — but only when chosen intentionally.\n\nHealthy snacking isn\'t about eating more. It\'s about eating smarter.',
      ),
      const GuideSection(
        heading: 'WHY SMART SNACKING MATTERS',
        content: 'A balanced snack helps regulate blood sugar, keeps cravings under control, and maintains steady energy throughout the day.\n\nWithout structure, however, snacking can quickly turn into mindless eating that pushes you beyond your daily calorie needs.',
      ),
      const GuideSection(
        heading: 'HEALTHY SNACKING PRINCIPLES',
        content: '**Keep It Light**\nAim for about 250 calories or fewer so your snack supports — rather than replaces — your next meal.\n\n**Combine Protein and Fibre**\nThis pairing slows digestion and helps you stay full longer, reducing the urge to keep reaching for more food.\n\n**Check Your Hunger**\nPause before eating and ask yourself whether you\'re physically hungry or simply bored, tired, or stressed. Awareness alone can prevent unnecessary snacking.',
      ),
      const GuideSection(
        heading: 'SMART SNACK OPTIONS',
        content: '**DIY Trail Mix**\nA mix of raw nuts and dried fruit delivers protein, fibre, and lasting energy.\n\n**Cheese and Fruit**\nProtein from cheese paired with fibre-rich fruit creates a satisfying balance that curbs appetite without feeling heavy.\n\n**Greek Yogurt with Berries**\nPlain Greek yogurt offers protein and creaminess without excess sugar. Add fresh berries for fibre and natural sweetness.\n\n**Whole Grains with Nut Butter**\nWhole grain crackers or pita paired with nut butter provide steady energy.\n\n**Vegetables with Hummus**\nCrunchy vegetables like carrots, celery, or peppers paired with hummus deliver nutrients with relatively few calories.',
      ),
      const GuideSection(
        heading: 'CONCLUSION',
        content: 'When hunger hits, don\'t ignore it — but don\'t respond automatically either. Choose snacks that nourish your body, stabilize your energy, and keep you satisfied until your next meal.\n\nSmart snacking isn\'t about restriction. It\'s about consistency and awareness.',
      ),
    ],
  ),

  Guide(
    id: 'plant-based-diet',
    title: '2 Landmark Studies on the Benefits of a Plant-Based Diet',
    subtitle: 'What long-term research reveals about health, longevity, and environmental impact',
    emoji: '🥦',
    sections: [
      const GuideSection(
        heading: '',
        content: 'A plant-based diet focuses on fruits, vegetables, whole grains, legumes, nuts, and seeds while limiting or avoiding animal products. Some people adopt it fully, while others gradually reduce animal foods — both approaches can support meaningful health improvements.',
      ),
      const GuideSection(
        heading: 'WHAT IS A PLANT-BASED DIET?',
        content: 'At its core, this approach emphasizes nutrient-dense whole foods from plants while minimizing heavily processed items and animal-based products.\n\nIt doesn\'t have to be all-or-nothing. Even increasing plant intake can deliver measurable benefits.',
      ),
      const GuideSection(
        heading: 'LANDMARK RESEARCH FINDINGS',
        content: '**The Adventist Health Study**\nOne of the largest nutrition studies ever conducted followed over 96,000 adults across North America.\n\n• Vegetarian diets were linked to a lower risk of heart disease and diabetes.\n• Higher intake of vegetables, legumes, dried fruits, and whole grains was associated with a reduced risk of colon polyps.\n• Plant-forward eaters reported a higher overall quality of life.\n\n**The EPIC-Oxford Study**\nThis long-running European study tracked roughly 65,000 participants.\n\n• Vegan participants consumed more fibre and less saturated fat.\n• They tended to have healthier body weights and improved cholesterol levels.\n• Blood pressure levels were lowest among those eating fully plant-based diets.',
      ),
      const GuideSection(
        heading: 'BENEFITS BEYOND PERSONAL HEALTH',
        content: 'Dietary choices don\'t just affect the body — they also influence environmental sustainability.\n\nProducing protein from beans instead of beef requires dramatically fewer resources:\n\n• Far less land\n• Less water\n• Reduced fuel use\n• Lower fertilizer demand\n• Fewer pesticides\n\nPlant-forward diets are widely associated with a smaller environmental footprint.',
      ),
      const GuideSection(
        heading: 'CONCLUSION',
        content: 'Evidence from large-scale studies continues to support the benefits of eating more plant-based foods. This approach is linked to improved heart health, better metabolic markers, and a reduced environmental burden.\n\nYou don\'t have to aim for perfection — progress toward more plant-focused meals is what drives results.',
      ),
    ],
  ),

  Guide(
    id: 'sleep-hygiene',
    title: 'Sleep Hygiene: Simple Practices for Better Rest',
    subtitle: 'Small habits that improve sleep quality, recovery, and daily performance',
    emoji: '😴',
    sections: [
      const GuideSection(
        heading: '',
        content: 'Quality sleep is one of the most powerful tools for supporting physical health, mental clarity, and emotional balance. A truly restorative night isn\'t just about hours slept — it\'s also about falling asleep efficiently and staying asleep.\n\nMany people struggle with inconsistent rest, frequent awakenings, or difficulty drifting off. The good news: simple behavioral changes can dramatically improve sleep.',
      ),
      const GuideSection(
        heading: 'WHAT IS SLEEP HYGIENE?',
        content: 'Sleep hygiene refers to the daily habits and environmental factors that influence how well you sleep.\n\nWhen sleep is consistent and restorative, your body can properly repair tissues, strengthen immunity, and reset cognitive function.',
      ),
      const GuideSection(
        heading: 'CORE SLEEP HYGIENE PRINCIPLES',
        content: '**Keep a Consistent Schedule**\nAim for roughly 7–9 hours of sleep each night and maintain regular sleep and wake times whenever possible.\n\n**Personalize Your Routine**\nSleep needs vary from person to person. Pay attention to how you feel during the day and adjust your habits accordingly.\n\n**Support Sleep With Daytime Behavior**\nYour choices throughout the day — from exercise to caffeine intake — directly impact how easily you fall asleep at night.',
      ),
      const GuideSection(
        heading: 'CREATE A SLEEP-FRIENDLY ENVIRONMENT',
        content: '• Keep the room slightly cool.\n• Reduce noise or use soft background sound if needed.\n• Block excess light with curtains or shades.\n• Replace uncomfortable mattresses or pillows.\n• Reserve the bedroom primarily for sleep.\n• Keep electronics and work-related items elsewhere.',
      ),
      const GuideSection(
        heading: 'DON\'T LET FOOD OR STIMULANTS DISRUPT YOUR REST',
        content: '• Finish large meals at least three hours before bedtime.\n• Limit alcohol in the evening, as it can fragment sleep later in the night.\n• Avoid caffeine late in the day if you\'re sensitive to it.\n• Steer clear of nicotine, which acts as a stimulant.',
      ),
      const GuideSection(
        heading: 'BUILD A RELAXING BEDTIME ROUTINE',
        content: 'Give your brain time to slow down before sleep. Consider setting aside about an hour to unwind:\n\n• Put away stimulating devices\n• Read in soft lighting\n• Take a warm bath\n• Practice gentle stretching or deep breathing\n\nRepeated nightly cues train your brain to recognize when it\'s time to rest.',
      ),
      const GuideSection(
        heading: 'DAYTIME HABITS THAT IMPROVE NIGHTTIME SLEEP',
        content: '**Time Exercise Strategically**\nSome people sleep better after daytime workouts, while others tolerate evening exercise well.\n\n**Be Mindful With Naps**\nIf needed, keep naps short and earlier in the day.\n\n**Track Your Patterns**\nA simple sleep log — noting bedtime, caffeine intake, exercise, and screen use — can reveal hidden behaviors that affect your rest.',
      ),
      const GuideSection(
        heading: 'CONCLUSION',
        content: 'Restorative sleep is foundational to long-term health. By shaping your environment, stabilizing your routine, and making intentional daily choices, you can create conditions that allow your body and mind to fully recharge.\n\nBetter nights lead to stronger, more focused days.',
      ),
    ],
  ),

  Guide(
    id: 'steady-energy',
    title: 'The Best Foods for Steady Energy',
    subtitle: 'Nutrient-dense choices that help reduce fatigue and support consistent performance',
    emoji: '⚡',
    sections: [
      const GuideSection(
        heading: '',
        content: 'Your energy levels are heavily influenced by what you eat. While highly processed foods often cause spikes and crashes, whole foods provide steady fuel that supports focus, stamina, and metabolic health.\n\nLasting energy comes from balanced nutrition — not quick fixes.',
      ),
      const GuideSection(
        heading: 'WHAT SUPPORTS STABLE ENERGY?',
        content: 'Choose foods that:\n\n• Release energy gradually\n• Support oxygen delivery\n• Provide key vitamins and minerals\n• Help regulate blood sugar\n\nConsistency matters more than any single "superfood."',
      ),
      const GuideSection(
        heading: 'ENERGY-SUPPORTING FOODS',
        content: '**Lean Beef** — Rich in absorbable iron and vitamin B12, supports oxygen transport.\n\n**Chickpeas** — Complex carbohydrates and zinc provide slow, reliable fuel.\n\n**Mushrooms** — B vitamins and vitamin D support energy production.\n\n**Kiwis** — High in vitamin C and antioxidants that help combat fatigue.\n\n**Macadamia Nuts** — Healthy fats and vitamin B1 for long-lasting fuel.\n\n**Bananas** — Natural sugars paired with fiber deliver quick yet stable energy.\n\n**Kefir** — Probiotics support gut health, improving nutrient absorption.\n\n**Sweet Potatoes** — Complex carbs release glucose gradually.\n\n**Spinach** — Iron and magnesium support oxygen flow and energy metabolism.\n\n**Eggs** — Protein and B vitamins help convert stored nutrients into usable energy.\n\n**Oats** — Slow-digesting carbohydrates help stabilize blood sugar.\n\n**Apples** — Natural carbs provide immediate energy, while fiber extends it.',
      ),
      const GuideSection(
        heading: 'CONCLUSION',
        content: 'Build meals around protein, fiber, and healthy fats to maintain consistent energy throughout the day.\n\nRemember — nutrition works best when paired with quality sleep, hydration, movement, and stress management.\n\nStable energy starts with consistent food choices. Prioritizing nutrient-dense options can help you stay alert, productive, and resilient from morning to night.',
      ),
    ],
  ),

  Guide(
    id: 'hydration',
    title: 'Stay Hydrated the Natural Way',
    subtitle: 'How foods, electrolytes, and simple habits support energy and overall health',
    emoji: '💧',
    sections: [
      const GuideSection(
        heading: '',
        content: 'Hydration isn\'t just about drinking water. It\'s a whole-body process influenced by nutrition, activity level, and electrolyte balance. When hydration is optimized, it supports energy, digestion, focus, and physical performance.',
      ),
      const GuideSection(
        heading: 'WHY HYDRATION MATTERS',
        content: 'The body is made up of roughly 60% water, and even mild dehydration can affect mood, stamina, and cognitive function.\n\nProper hydration helps:\n\n• Transport nutrients\n• Regulate body temperature\n• Support joints\n• Remove waste\n• Reduce strain on the heart and kidneys',
      ),
      const GuideSection(
        heading: 'HYDRATING FOODS TO PRIORITIZE',
        content: 'Many fruits and vegetables contain over 90% water, making them powerful hydration allies.\n\n• Cucumber\n• Lettuce\n• Celery\n• Tomatoes\n• Zucchini\n• Watermelon\n• Strawberries\n• Cantaloupe\n• Oranges\n\nThese foods also provide fiber, antioxidants, and natural sugars that support fluid absorption.',
      ),
      const GuideSection(
        heading: 'DON\'T FORGET ELECTROLYTES',
        content: 'Electrolytes — including sodium, potassium, magnesium, and calcium — help regulate fluid balance and support muscle and nerve function.\n\nYou may benefit from additional electrolytes if you:\n\n• Sweat heavily\n• Exercise frequently\n• Follow low-carb or fasting protocols\n• Drink large amounts of water\n\nAvoid overly processed sports drinks when possible and choose cleaner options with minimal added sugar.',
      ),
      const GuideSection(
        heading: 'HOW MUCH WATER DO YOU NEED?',
        content: 'Hydration needs vary based on body size, activity, and environment.\n\n**Simple indicator:**\nLight yellow urine typically signals adequate hydration.\n\n• Darker color → increase fluids\n• Completely clear → consider reducing plain water or adding electrolytes\n\nBoth dehydration and overhydration can disrupt balance.',
      ),
      const GuideSection(
        heading: 'SIMPLE WAYS TO STAY HYDRATED',
        content: '• Start the day with a glass of water\n• Add natural flavor like lemon, mint, or berries\n• Choose water-rich snacks\n• Drink consistently — don\'t wait for thirst\n• Alternate electrolytes with plain water during intense activity',
      ),
      const GuideSection(
        heading: 'CONCLUSION',
        content: 'Consistent hydration is one of the easiest ways to improve how your body functions each day. By pairing fluid intake with nutrient-rich foods and balanced electrolytes, you create a foundation for sustained energy, clarity, and resilience.',
      ),
    ],
  ),
];
