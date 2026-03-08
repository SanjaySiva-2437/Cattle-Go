// lib/data/breed_data.dart
import '../models/breed_model.dart';

List<Breed> indianBreeds = [
  // Cattle Breeds
  Breed(
    id: '1',
    name: 'Gir',
    type: 'Cattle',
    origin: 'Gujarat, India',
    description:
        'The Gir is one of the principal Zebu breeds originating from India. Known for its distinctive curved horns and drooping ears, it is primarily bred for milk production and is highly adaptable to various climatic conditions.',
    milkYield: '1500-2000 kg per lactation',
    marketValue: '₹50,000 - ₹1,50,000',
    keyTrait: 'High milk fat content (4.5-5%)',
    imageUrl: 'assets/images/gir_cow.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Distinctive curved horns',
      'Drooping ears',
      'White or red spotted coat',
      'High heat tolerance',
      'Good disease resistance'
    ],
  ),
  Breed(
    id: '2',
    name: 'Sahiwal',
    type: 'Cattle',
    origin: 'Punjab region (India/Pakistan)',
    description:
        'The Sahiwal is a breed of Zebu cattle known primarily as a dairy breed. They are reddish dun in color, with varying shades of red. Sahiwal is considered one of the best dairy breeds in India and Pakistan.',
    milkYield: '2000-3000 kg per lactation',
    marketValue: '₹40,000 - ₹1,20,000',
    keyTrait: 'Excellent milk production in hot climates',
    imageUrl: 'assets/images/sahiwal_cow.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Reddish dun color',
      'Short horns',
      'Loose skin',
      'Heat tolerant',
      'Good milk production'
    ],
  ),
  Breed(
    id: '3',
    name: 'Red Sindhi',
    type: 'Cattle',
    origin: 'Sindh region (Pakistan)',
    description:
        'The Red Sindhi is a dairy breed of cattle that is primarily used for milk production. They are known for their heat tolerance and are found in various parts of India.',
    milkYield: '1200-1800 kg per lactation',
    marketValue: '₹35,000 - ₹90,000',
    keyTrait: 'Good heat tolerance and milk production',
    imageUrl: 'assets/images/red_sindhi_cow.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Deep red color',
      'Medium size',
      'Heat tolerant',
      'Good milk quality',
      'Disease resistant'
    ],
  ),
  Breed(
    id: '4',
    name: 'Kangayam',
    type: 'Cattle',
    origin: 'Tamil Nadu, India',
    description:
        'The Kangayam is a popular and well-known breed of cattle from Tamil Nadu. It is a strong draught breed, known for its endurance and ability to pull heavy loads. They are also used in the traditional sport of Jallikattu.',
    milkYield: '500-800 kg per lactation',
    marketValue: '₹30,000 - ₹80,000',
    keyTrait: 'Excellent draught capacity',
    imageUrl: 'assets/images/kangayam_cow.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Grey or white color',
      'Strong build',
      'Excellent draught animal',
      'Heat resistant',
      'Used in Jallikattu'
    ],
  ),
  Breed(
    id: '5',
    name: 'Ongole',
    type: 'Cattle',
    origin: 'Andhra Pradesh, India',
    description:
        'The Ongole is an indigenous cattle breed that originates from the Prakasam District in Andhra Pradesh. Ongole cattle are known for their toughness, high milk yield, and resistance to disease.',
    milkYield: '1000-1500 kg per lactation',
    marketValue: '₹45,000 - ₹1,00,000',
    keyTrait: 'Dual-purpose breed',
    imageUrl: 'assets/images/ongole_cow.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'White or light grey color',
      'Large hump',
      'Strong and muscular',
      'Dual purpose',
      'Disease resistant'
    ],
  ),

  // Buffalo Breeds
  Breed(
    id: '6',
    name: 'Murrah',
    type: 'Buffalo',
    origin: 'Haryana, India',
    description:
        'The Murrah is a breed of water buffalo primarily kept for milk production. It is known for its high milk yield and has been used to improve the milk production of other buffalo breeds.',
    milkYield: '1500-2500 kg per lactation',
    marketValue: '₹60,000 - ₹2,00,000',
    keyTrait: 'Highest milk yielding buffalo breed',
    imageUrl: 'assets/images/murrah_buffalo.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Jet black color',
      'Short, tightly curved horns',
      'Strong limbs',
      'High milk yield',
      'Good adaptability'
    ],
  ),
  Breed(
    id: '7',
    name: 'Surti',
    type: 'Buffalo',
    origin: 'Gujarat, India',
    description:
        'The Surti breed of buffalo is a native of Kaira and Vadodara districts of Gujarat. These animals are well adapted to the climatic conditions of the region and are known for their high-fat milk.',
    milkYield: '1200-1800 kg per lactation',
    marketValue: '₹50,000 - ₹1,50,000',
    keyTrait: 'High butterfat content in milk',
    imageUrl: 'assets/images/surti_buffalo.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Brown or black color',
      'Medium size',
      'Copper-colored horns',
      'High fat milk',
      'Good temperament'
    ],
  ),
  Breed(
    id: '8',
    name: 'Jaffarabadi',
    type: 'Buffalo',
    origin: 'Gujarat, India',
    description:
        'The Jaffarabadi buffalo is a riverine buffalo that originated in the Jaffarabad district of Gujarat. It is one of the heaviest buffalo breeds and is known for its high milk yield.',
    milkYield: '1800-2700 kg per lactation',
    marketValue: '₹70,000 - ₹2,50,000',
    keyTrait: 'Heaviest Indian buffalo breed',
    imageUrl: 'assets/images/jaffarabadi_buffalo.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Massive size',
      'Long, curved horns',
      'High milk production',
      'Good for draught',
      'Strong build'
    ],
  ),
  Breed(
    id: '9',
    name: 'Bhadawari',
    type: 'Buffalo',
    origin: 'Uttar Pradesh & Madhya Pradesh, India',
    description:
        'The Bhadawari buffalo is a breed of water buffalo from the Bhadawar region. It is known for its ability to survive in difficult conditions and its milk has a very high butterfat content.',
    milkYield: '800-1200 kg per lactation',
    marketValue: '₹40,000 - ₹1,00,000',
    keyTrait: 'Highest butterfat content (8-13%)',
    imageUrl: 'assets/images/bhadawari_buffalo.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Light brown color',
      'Medium horns',
      'High fat milk',
      'Hardy breed',
      'Good for poor quality feed'
    ],
  ),
  Breed(
    id: '10',
    name: 'Nili-Ravi',
    type: 'Buffalo',
    origin: 'Punjab region (India/Pakistan)',
    description:
        'The Nili-Ravi is a breed of domestic water buffalo. It is distributed mostly in the Punjab region. It is similar to the Murrah buffalo and is another highly productive dairy breed.',
    milkYield: '1600-2400 kg per lactation',
    marketValue: '₹55,000 - ₹1,80,000',
    keyTrait: 'Excellent dairy breed with white markings',
    imageUrl: 'assets/images/nili_ravi_buffalo.jpg', // Local asset path
    modelSrc: 'assets/cow.glb',
    characteristics: [
      'Black with white markings',
      'Wall eyes',
      'White switch of tail',
      'High milk yield',
      'Good temperament'
    ],
  ),
];
