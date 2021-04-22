import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'loading': 'loading..',
          'error': 'Error',
          'success': 'Success!',
          //snackbar texts
          'empty_field_warning_title': 'Empty Field',
          'empty_field_warning_message': 'You saved an empty Field',
          'empty_schedule_warning_title': 'Empty Schedule',
          'empty_schedule_warning_message': 'You saved an empty Schedule',
          'no_rewards_warning_title': 'No Rewards',
          'no_rewards_warning_message': 'You have no saved Rewards',
          'habit_deleted_message': 'Your Habit was deleted',
          'reward_deleted_message': 'Your Reward was deleted',
          //example habit
          'example_title': 'Example',
          'example_description': 'This is an Example.',
          //example rewards
          'example_reward_title_1': 'Eat some sweets',
          'example_reward_description_1': '...',
          'example_reward_title_2': 'Watch your favourite show"',
          'example_reward_description_2': '20 minute Adventure',
          'example_reward_title_3': 'Sleep late',
          'example_reward_description_3': 'A very powerful nap',
          'example_reward_title_4': 'Take a Day off',
          'example_reward_description_4': 'Be the lazy Bird',
          //tutorial
          'homeScreenTutorial_container_heading': 'Habits',
          'homeScreenTutorial_container_message':
              'Your Habits get Displayed by these Containers.',
          'homeScreenTutorial_completionrow_heading': 'Completions',
          'homeScreenTutorial_completionrow_message':
              'This row shows you, how many times this Habit need to be completed today.',
          'homeScreenTutorial_completeButton_heading': 'Complete Habit',
          'homeScreenTutorial_completeButton_message':
              'Tap this button, to add a completion to this habit.',
          'completionTutorial_drawerExtension_heading': 'Menu',
          'completionTutorial_drawerExtension_message':
              'Auf Bildschirmen mit diesem Element kannst du zur Seite wischen, um das Menü aufzurufen.',
          'detailScreenTutorial_scheduleRowKey_heading': '',
          'detailScreenTutorial_scheduleRowKey_message': '',
          'detailScreenTutorial_editButton_heading': '',
          'detailScreenTutorial_editButton_message': '',
          'detailScreenTutorial_rewardList_heading': '',
          'detailScreenTutorial_rewardList_message': '',
          //screens
          //createItemScreen
          'createItemScreen_create_title': 'Create a ...',
          'habit': 'Habit',
          'reward': 'Reward',
          'frequenzy': 'Frequenzy',
          'one_time': 'Once',
          'regular': 'Regular',
          'frequenzy_explanation':
              'If you select "Once", the Reward will get removed from your List after it appeared.',
          'create_Button_title': 'Create',
          'title': 'Title',
          'title_textfield_hint': 'Your Title',
          'title_missing_warning': 'Please chose a Title',
          'number_range_hint':
              'Hint: You can type in a number range e.g. "2-5" to get an even more randomized Reward!',
          'invalid_range_title': 'Invalid Range',
          'invalid_range_message':
              'Please make sure "min" is not greater than "max"',
          'warning': 'Warning',
          'times_per_day': 'Times per Day',
          'description': 'Description',
          'description_textfield_hint': 'Your Description',
          'rewards': 'Rewards',
          'reward_missing_warning': 'Please select at least one Reward',
          'schedule': 'Schedule',
          'missing_schedule_warning': 'Please schedule at least one Day',
          //Habit detail screen
          'save_habit': 'Save Habit',
          'edit_habit': 'Edit Habit',
          'delete_habit': 'Delete Habit',
          //Reward detail screen
          'save_reward': 'Save Reward',
          'edit_reward': 'Edit Reward',
          'delete_reward': 'Delete Reward',
          //Menu Screen
          'today_habits_menutitle': 'Today',
          'create_new_menutitle': 'Create',
          'my_content_menutitle': 'All',
          //My Content Screen
          'scroll_to_show_rewards': 'Rewards',
          'scroll_to_show_habits': 'Habits',
          //Widgets
          //HabitCompletionChart
          'this_week': 'This Week',
          'last_four_weeks': 'Last Month',
          'today': 'Today',
          'monday': 'Monday',
          'tuesday': 'Tuesday',
          'wednesday': 'Wednesday',
          'thursday': 'Thursday',
          'friday': 'Friday',
          'saturday': 'Saturday',
          'sunday': 'Sunday',
          //Translating weekdays
          'Mo': 'Mo',
          'Tu': 'Tu',
          'We': 'We',
          'Th': 'Th',
          'Fr': 'Fr',
          'Sa': 'Sa',
          'Su': 'Su',
        },
        'de_DE': {
          'loading': 'lade..',
          'error': 'Fehler',
          'success': 'Erfolg!',
          //snackbar texts
          'empty_field_warning_title': 'Leeres Feld',
          'empty_field_warning_message': 'Du hast ein leeres Feld gespeichert',
          'empty_schedule_warning_title': 'Leerer Tagesplan ',
          'empty_schedule_warning_message':
              'Du hast einen leeren Tagesplan gespeichert',
          'no_rewards_warning_title': 'Keine Belohnungen',
          'no_rewards_warning_message':
              'Es wurden keine Belohnungen gespeichert',
          'habit_deleted_message': 'Deine Gewohnheit wurde gelöscht',
          'reward_deleted_message': 'Deine Belohnung wurde gelöscht',
          //example habit
          'example_title': 'Beispiel',
          'example_description': 'Beispiel',
          //example rewards
          'example_reward_title_1': 'Eat some sweets',
          'example_reward_description_1': '...',
          'example_reward_title_2': 'Watch your favourite show"',
          'example_reward_description_2': '20 minute Adventure',
          'example_reward_title_3': 'Sleep late',
          'example_reward_description_3': 'A very powerful nap',
          'example_reward_title_4': 'Take a Day off',
          'example_reward_description_4': 'Be the lazy Bird',
          //tutorial
          'homeScreenTutorial_container_heading': 'Gewohnheiten',
          'homeScreenTutorial_container_message':
              'Deine täglichen Gewohnheiten werden als Container angezeigt.',
          'homeScreenTutorial_completionrow_heading': 'Tagesziel',
          'homeScreenTutorial_completionrow_message':
              'Diese Reihe zeigt dir dein heutiges Tagesziel',
          'homeScreenTutorial_completeButton_heading': 'Abschluss hinzufügen',
          'homeScreenTutorial_completeButton_message':
              'Mit diesem Button kannst du der Gewohnheit einen Abschluss hinzufügen.',
          'completionTutorial_drawerExtension_heading': 'Menü',
          'completionTutorial_drawerExtension_message':
              'Auf Bildschirmen mit diesem Element kannst du zur Seite wischen, um das Menü aufzurufen.',
          'detailScreenTutorial_scheduleRowKey_heading': 'Zeitplan',
          'detailScreenTutorial_scheduleRowKey_message': '',
          'detailScreenTutorial_editButton_heading': 'Bearbeiten/Speichern',
          'detailScreenTutorial_editButton_message':
              'Mit diesem Button kannst du in den Bearbeitungsmodus wechseln und deine Änderungen speichern. Probier es aus!',
          'detailScreenTutorial_rewardList_heading': 'Belohnungen',
          'detailScreenTutorial_rewardList_message':
              'Hier siehst du alle aktiven Belohnungen für deine Gewohnheit.',
          //screens
          //createItemScreen
          'createItemScreen_create_title': 'Erstelle eine neue ...',
          'habit': 'Gewohnheit',
          'reward': 'Belohnung',
          'frequenzy': 'Frequenz',
          'one_time': 'Einmalig',
          'regular': 'Wiederholend',
          'frequenzy_explanation':
              'Wenn du "Einmalig" auswählst, wird die Belohnung aus der Liste entfernt, sobald sie aufgetreten ist.',
          'create_Button_title': 'Erstellen',
          'title': 'Titel',
          'title_textfield_hint': 'Dein Titel',
          'title_missing_warning': 'Bitte gib einen Titel ein',
          'number_range_hint':
              'Hinweis: Du kannst eine Zahlenspanne z.B. 2-5 eingeben, um eine noch spannendere Belohnung zu erstellen!',
          'invalid_range_title': 'Ungültige Zahlenspanne',
          'invalid_range_message':
              'Please make sure "min" is not greater than "max"',
          'warning': 'Achtung',
          'times_per_day': 'Wie oft pro Tag?',
          'description': 'Beschreibung',
          'description_textfield_hint': 'Deine Beschreibung (Optional)',
          'rewards': 'Belohnungen',
          'reward_missing_warning': 'Bitte wähle mindestens eine Belohnung',
          'schedule': 'Zeitplan',
          'missing_schedule_warning': 'Bitte wähle mindestens einen Tag',
          //Habit detail screen
          'save_habit': 'Speichern',
          'edit_habit': 'Bearbeiten',
          'delete_habit': 'Löschen',
          //Reward detail screen
          'save_reward': 'Speichern',
          'edit_reward': 'Bearbeiten',
          'delete_reward': 'Löschen',
          //Menu Screen
          'today_habits_menutitle': 'Heute',
          'create_new_menutitle': 'Erstellen',
          'my_content_menutitle': 'Alle',
          //My Content Screen
          'scroll_to_show_rewards': 'Belohnungen',
          'scroll_to_show_habits': 'Gewohnheiten',
          //Widgets
          //HabitCompletionChart
          'this_week': 'Diese Woche',
          'last_four_weeks': 'Letzter Monat',
          'today': 'Heute',
          'monday': 'Montag',
          'tuesday': 'Dienstag',
          'wednesday': 'Mittwoch',
          'thursday': 'Donnerstag',
          'friday': 'Freitag',
          'saturday': 'Samstag',
          'sunday': 'Sonntag',
          //Translating weekdays
          'Mo': 'Mo',
          'Tu': 'Di',
          'We': 'Mi',
          'Th': 'Do',
          'Fr': 'Fr',
          'Sa': 'Sa',
          'Su': 'So',
        }
      };
}
