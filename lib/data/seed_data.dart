/// Canonical seed content for the app. Used both to populate Firestore
/// (first run) and as an offline fallback if Firestore is unreachable.
class SeedData {
  static const int contentVersion = 2;

  static const List<Map<String, dynamic>> scriptures = [
    {
      'id': 'psalms_55_22',
      'text':
          'Cast your cares on the Lord and he will sustain you; he will never let the righteous be shaken.',
      'reference': 'Psalms 55:22',
      'order': 0,
      'isPriority': true,
    },
    {
      'id': 'peter_5_6_7',
      'text':
          'Humble yourselves, therefore, under the mighty hand of God, so that he may exalt you at the proper time, casting all your cares on him, because he cares about you.',
      'reference': '1 Peter 5:6-7',
      'order': 1,
      'isPriority': false,
    },
    {
      'id': 'matthew_11_28_30',
      'text':
          'Come to me, all you who are weary and burdened, and I will give you rest. Take my yoke upon you and learn from me, for my yoke is easy and my burden is light.',
      'reference': 'Matthew 11:28-30',
      'order': 2,
      'isPriority': false,
    },
    {
      'id': 'galatians_6_2',
      'text':
          'Carry each other’s burdens, and in this way you will fulfill the law of Christ.',
      'reference': 'Galatians 6:2',
      'order': 3,
      'isPriority': false,
    },
    {
      'id': 'philippians_4_6_7',
      'text':
          'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.',
      'reference': 'Philippians 4:6-7',
      'order': 4,
      'isPriority': false,
    },
    {
      'id': 'proverbs_3_5_6',
      'text':
          'Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.',
      'reference': 'Proverbs 3:5-6',
      'order': 5,
      'isPriority': false,
    },
  ];

  static const List<Map<String, dynamic>> breathQuotes = [
    {
      'id': 'b1',
      'text': 'Cast this into God’s hands—He cares for you.',
      'order': 0,
    },
    {'id': 'b2', 'text': 'You don’t have to carry this alone.', 'order': 1},
    {
      'id': 'b3',
      'text': 'Place this into God’s hands—He cares for you.',
      'order': 2,
    },
    {
      'id': 'b4',
      'text': 'Cast this upon Him, for He cares for you.',
      'order': 3,
    },
    {
      'id': 'b5',
      'text': 'You don’t have to carry this—God is with you in it.',
      'order': 4,
    },
    {
      'id': 'b6',
      'text': 'Surrender this to God—He is faithful to carry what you cannot.',
      'order': 5,
    },
    {
      'id': 'b7',
      'text': 'Rest this in God’s hands—He sees you and cares deeply.',
      'order': 6,
    },
  ];

  static const List<Map<String, dynamic>> releaseQuotes = [
    {'id': 'r1', 'text': 'It’s in God’s hands now. Rest.', 'order': 0},
    {'id': 'r2', 'text': 'Let it go. Breathe. God is with you.', 'order': 1},
    {
      'id': 'r3',
      'text': 'You’ve given it to God. Rest in His care.',
      'order': 2,
    },
    {
      'id': 'r4',
      'text': 'It’s been released. You don’t have to carry it anymore.',
      'order': 3,
    },
    {
      'id': 'r5',
      'text': 'Your cares are in His hands now. He cares for you.',
      'order': 4,
    },
    {
      'id': 'r6',
      'text':
          'Your cares have been lifted. Trust that God is holding them now.',
      'order': 5,
    },
    {'id': 'r7', 'text': 'It rests in His hands now. So can you.', 'order': 6},
    {
      'id': 'r8',
      'text': 'Your burdens are in His hands. Be still and rest.',
      'order': 7,
    },
    {
      'id': 'r9',
      'text': 'What you carried is now in His care. Rest.',
      'order': 8,
    },
    {
      'id': 'r10',
      'text': 'You gave it to God. You don’t have to carry it anymore.',
      'order': 9,
    },
  ];

  static const List<Map<String, dynamic>> products = [
    {
      'id': 'mug',
      'title': 'Cast Your Cares Mug',
      'price': 12.99,
      'shortDesc': 'A daily reminder to release your worries & trust in Him.',
      'description':
          'Start your day with a gentle reminder that you don’t have to carry everything on your own. The Cast Your Cares Mug is more than just a cup—it’s a moment of peace in your daily routine. Designed with simplicity and meaning, this mug features the powerful message from Psalms 55:22, encouraging you to release your worries and trust in God’s care.',
      'imageUrl': 'assets/images/group1.png',
      'storeName': 'Castcares.com',
      'storeUrl': 'https://castcares.com',
      'active': true,
    },
    {
      'id': 'tshirt',
      'title': 'Faith T-Shirt',
      'price': 18.99,
      'shortDesc': 'Soft, everyday tee with a quiet reminder of faith.',
      'description':
          'A comfortable, everyday t-shirt carrying a quiet reminder to cast your cares and walk in faith. Made from soft, breathable cotton.',
      'imageUrl': 'assets/images/group2.png',
      'storeName': 'Castcares.com',
      'storeUrl': 'https://castcares.com',
      'active': true,
    },
    {
      'id': 'journal',
      'title': 'Prayer Journal',
      'price': 9.99,
      'shortDesc': 'Space to reflect, pray, and let go each day.',
      'description':
          'A guided prayer journal with space to reflect, give thanks, and lay down your burdens before God each day.',
      'imageUrl': 'assets/images/group3.png',
      'storeName': 'Castcares.com',
      'storeUrl': 'https://castcares.com',
      'active': true,
    },
    {
      'id': 'stickers',
      'title': 'Sticker Pack',
      'price': 4.99,
      'shortDesc': 'Faith-filled stickers for your everyday things.',
      'description':
          'A pack of faith-filled stickers to decorate your journal, laptop, or water bottle with gentle reminders of God’s care.',
      'imageUrl': 'assets/images/group1.png',
      'storeName': 'Castcares.com',
      'storeUrl': 'https://castcares.com',
      'active': true,
    },
  ];

  static const List<Map<String, dynamic>> faqs = [
    {
      'id': 'f1',
      'question': 'What is Cast Your Care?',
      'answer':
          'Cast Your Care (Carest) is a faith-based space to symbolically release your fears, worries, and burdens to God. Write what’s on your heart, cast it, and let it go—nothing you write is ever stored.',
      'order': 0,
    },
    {
      'id': 'f2',
      'question': 'Are my submissions saved anywhere?',
      'answer':
          'No. Your submissions are never stored, kept, or retrievable. The act is purely symbolic—once you cast your care, it is gone.',
      'order': 1,
    },
    {
      'id': 'f3',
      'question': 'Is the app free?',
      'answer':
          'Yes, Carest is free for everyone. It is supported by optional donations and store purchases, which help keep it free.',
      'order': 2,
    },
    {
      'id': 'f4',
      'question': 'How does the scripture rotation work?',
      'answer':
          'Each time you open the app, an uplifting scripture greets you. Psalms 55:22 appears first, and the scriptures rotate on later visits.',
      'order': 3,
    },
    {
      'id': 'f5',
      'question': 'Can I turn off the background music?',
      'answer': 'Yes. You can toggle music on or off anytime from Settings.',
      'order': 4,
    },
    {
      'id': 'f6',
      'question': 'How do donations help?',
      'answer':
          'Donations are completely voluntary and help cover the cost of keeping Carest free and available for everyone.',
      'order': 5,
    },
  ];

  static const Map<String, dynamic> privacy = {
    'title': 'Privacy Policy',
    'lastUpdated': 'Last updated Dec 23, 2035',
    'sections': [
      {
        'heading': 'Introduction',
        'body':
            'Carest is built around privacy. The words you write when casting your cares are never stored, logged, or transmitted to any server—they exist only on your device for the moment of the experience and are discarded immediately after.',
      },
      {
        'heading': 'What we store',
        'body':
            'We keep only anonymous, non-personal data needed for the app to function: a count of burdens released, your app settings (such as music and notifications), and any store orders or donations you choose to make. We never associate this with your identity.',
      },
    ],
  };

  static const Map<String, dynamic> terms = {
    'title': 'Terms & Conditions',
    'lastUpdated': 'Last updated Dec 23, 2035',
    'sections': [
      {
        'heading': 'Introduction',
        'body':
            'By using Carest you agree to use the app for personal, reflective, and spiritual purposes. Carest is provided as-is, free of charge, and is not a substitute for professional mental health or medical care.',
      },
      {
        'heading': 'Purchases & Donations',
        'body':
            'Store purchases and donations are optional. Donations are non-refundable. Product orders are fulfilled according to the store’s policies.',
      },
    ],
  };

  static const Map<String, dynamic> appConfig = {
    'contentVersion': contentVersion,
    'splashRotationIndex': 0,
    'donationSuggestions': [5, 10, 15, 20, 25],
    'musicTrackUrl': '',
    'adsEnabled': false,
  };
}
