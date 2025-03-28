import 'package:elaros_gp4/Model/questionnaire_model.dart';

class QuestionnaireController {
  final List<Question> _questions = [
    Question(
      questionTitle: 'Question 1. Age Identification:',
      questionText: ['How Old is Your Child?'],
      answers: [
        ['1-2', '3-5', '6-13']
      ],
    ),
    Question(
      questionTitle: 'Question 2. Sleep Duration:',
      questionText: ['How Many Hours Does Your Child Sleep Per Night?'],
      answers: [
        ['11-14', '9-11', '8-10']
      ],
    ),
    Question(
      questionTitle: 'Question 3. Sleep Drive Factors:',
      questionText: [
        'Does Your Child Engage in Regular Physical Activity?',
        'Does Your Child Have a Set Wake-up Time Each Morning?'
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No']
      ],
    ),
    Question(
      questionTitle: 'Question 4. Circadian Rhythm Alignment:',
      questionText: [
        'Do You Keep Consistent Sleep and Wake Times for Your Child Everyday Including Weekends?',
        'Is Your Child Exposed to Natural Daylight Shortly After Waking Up?',
        'Do You Limit Exposure to Bright Light a Few Hours Before Bed?',
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No']
      ],
    ),
    Question(
      questionTitle: 'Question 5. Diet and Nutrition:',
      questionText: [
        'Does Your Child Eat a Large Meal Before Bedtime?',
        'Does Your Child Consume Food and/or Drink Containing Caffeine in the evening?',
        'Do You Offer Sleep-Friendly Snacks Before Bed (e.g. Cheese, Banana, Oats, Yoghurt, Milk)?',
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No']
      ],
    ),
    Question(
      questionTitle: 'Question 6. Physical Activity:',
      questionText: [
        'Does Your Child Participate in Sports/Physical Activities Throughout the Day?',
        'If Not Involved in Sports, Does Your Child Participate in Other Outdoor Activities Like Walking?'
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No']
      ],
    ),
    Question(
      questionTitle: 'Question 7. Relaxation Techniques:',
      questionText: [
        "Have You Introduced Relaxation Techniques to Your Child's Bedtime Routine?",
        'Does Your Child Practice Any Muscle Relaxation or Stretching Exercises Before Bed?'
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No']
      ],
    ),
    Question(
      questionTitle: 'Question 8. Sleep Environment:',
      questionText: [
        "Is Your Child's Bedroom Used Exclusively for Sleeping?",
        'Is the Bedroom Free from Distractions (e.g. Toys, Devices, Excessive Noise)?',
        'Does Your Child Prefer Total Darkness in the Room, a Nightlight, or Does it Vary?'
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'Sometimes', 'No'],
        ['Total Darkness', 'Nightlight', 'Varies']
      ],
    ),
    Question(
      questionTitle: 'Question 9. Technology Use:',
      questionText: [
        'Does Your Child Use Electronic Devices 1-2 Hours Before Bedtime?',
        'If So, are These Devices Used to Help them Fall Asleep?'
      ],
      answers: [
        ['Yes', 'Sometimes', 'No'],
        ['Yes', 'No', 'N/A']
      ],
    ),
  ];

  List<Question> get questions => _questions;
}
