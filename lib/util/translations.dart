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
          'invalid_time_title': '',
          'invalid_time_message': '',
          //example habit
          'example_title': 'Example',
          //example rewards
          'example_reward_title_1': 'Eat some sweets',
          'example_reward_title_2': 'Watch your favourite show',
          'example_reward_title_3': 'Sleep late',
          'example_reward_title_4': 'Take a Day off',
          //tutorial
          'tap': 'Tap Element:',
          'hold': 'Hold Element:',
          'welcomeScreen_welcome_heading': 'Welcome to Marbit',
          'welcomeScreen_welcome_message':
              'Do you want to watch an interactive tutorial?',
          'welcomeScreen_startButton_title': "Let's go!",
          'welcomeScreen_skipButton_title': "I'll figure it out myself.",
          'homeScreenTutorial_container_heading': 'Habits',
          'homeScreenTutorial_container_message':
              'Your Habits get displayed as Containers.',
          'completionScreenTutorial_completionrow_heading': 'Completions',
          'completionScreenTutorial_completionrow_message':
              'This row shows your daily completiongoal.',
          'homeScreenTutorial_completeButton_heading': 'Complete Habit',
          'homeScreenTutorial_completeButton_message':
              'Tap this button, to add a completion to this habit.',
          'completionTutorial_drawerExtension_heading': 'Menu',
          'completionTutorial_drawerExtension_message':
              'This Element shows you, on which Screens you can swipe to open the Menu.',
          'detailScreenTutorial_scheduleRowKey_heading': 'Schedule',
          'detailScreenTutorial_scheduleRowKey_message':
              'This is your current schedule.',
          'detailScreenTutorial_scheduleRowKey_tap': 'Select/Deselect',
          'detailScreenTutorial_scheduleRowKey_hold': 'Select/Deselect all',
          'detailScreenTutorial_completionGoalKey_heading': 'Daily Goal',
          'detailScreenTutorial_completionGoalKey_message':
              'This is your set daily Goal. You can change it in Edit mode.',
          'detailScreenTutorial_editButton_heading': 'Edit/Save',
          'detailScreenTutorial_editButton_message':
              'Pressing this Button once will activate Editmode. Pressing it again saves the changes.',
          'detailScreenTutorial_notificationTimesKey_heading': 'Reminders',
          'detailScreenTutorial_notificationTimesKey_message':
              'The number of reminders you can create matches your daily goal.',
          'detailScreenTutorial_notificationTimesKey_tap':
              'Activate/Deactivate.',
          'detailScreenTutorial_notificationTimesKey_hold': 'Edit time',
          'detailScreenTutorial_rewardList_heading': 'Rewards',
          'detailScreenTutorial_rewardList_message':
              'These are the selected rewards for this habit.',
          'homeScreenTutorial_details_heading': 'Details',
          'homeScreenTutorial_details_message':
              'Tap the Habit, to show details.',
          'detailScreenTutorial_statistics_heading': 'Statistics',
          'detailScreenTutorial_statistics_message':
              'These are your latest statistics for this Habit.',
          'detailScreenTutorial_statistics_hold': 'Further details',
          'completionStepTutorial_complete_heading': 'Complete',
          'completionStepTutorial_complete_message':
              'Complete this habit to get your first reward!',
          //screens
          //createItemScreen
          'createItemScreen_create_title': 'Create a ...',
          'habit': 'Habit',
          'reward': 'Reward',
          'frequenzy': 'Frequency',
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

          'notification_times': 'Notification Times',
          'rewards': 'Rewards',
          'reward_missing_warning': 'Please select at least one Reward',
          "no_rewards_caption" : "You don't have any rewards yet.",
          'create_reward_button' : 'Create',
          'schedule': 'Schedule',
          'missing_schedule_warning': 'Please schedule at least one Day',
          //Rewardpopup Screen
          'streak_message': 'You are on a @streak day streak!',
          'motivational_message': 'Keep going!',
          //Habit detail screen
          'save_habit': 'Save Habit',
          'edit_habit': 'Edit Habit',
          'per_day': 'per Day',
          'delete_habit': 'Delete Habit',
          'Week': 'Week ',
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
          'invalid_time_title': '',
          'invalid_time_message': '',
          //example habit
          'example_title': 'Beispiel',
          //example rewards
          'example_reward_title_1': 'Gönn dir was süßes',
          'example_reward_title_2': 'Schau deine Lieblingsserie',
          'example_reward_title_3': 'Schlaf dich aus',
          'example_reward_title_4': 'Nimm dir einen Tag frei',
          //tutorial
          'tap': 'Element Tippen:',
          'hold': 'Element Gedrückt halten:',
          'welcomeScreen_welcome_heading': 'Willkommen bei Marbit',
          'welcomeScreen_welcome_message':
              'Möchtest du das interaktive Tutorial sehen?',
          'welcomeScreen_startButton_title': "Los geht's!",
          'welcomeScreen_skipButton_title': 'Ich finde mich selbst zurecht',
          'homeScreenTutorial_container_heading': 'Gewohnheiten',
          'homeScreenTutorial_container_message':
              'Deine täglichen Gewohnheiten werden als Container angezeigt.',
          'completionScreenTutorial_completionrow_heading': 'Tagesziel',
          'completionScreenTutorial_completionrow_message':
              'Diese Reihe zeigt dir dein heutiges Tagesziel',
          'homeScreenTutorial_completeButton_heading': 'Abschluss hinzufügen',
          'homeScreenTutorial_completeButton_message':
              'Mit diesem Button kannst du der Gewohnheit einen Abschluss hinzufügen.',
          'completionTutorial_drawerExtension_heading': 'Menü',
          'completionTutorial_drawerExtension_message':
              'Auf Bildschirmen mit diesem Element kannst du zur Seite wischen, um das Menü aufzurufen.',
          'detailScreenTutorial_scheduleRowKey_heading': 'Zeitplan',
          'detailScreenTutorial_scheduleRowKey_message':
              'Dies ist dein aktueller Zeitplan.',
          'detailScreenTutorial_scheduleRowKey_tap': 'Aktivieren/Deaktivieren',
          'detailScreenTutorial_scheduleRowKey_hold':
              'Alle Aktivieren/Deaktivieren',

          'detailScreenTutorial_completionGoalKey_heading': 'Tagesziel',
          'detailScreenTutorial_completionGoalKey_message':
              'Du kannst dein Tagesziel im Bearbeitungsmodus ändern.',
          'detailScreenTutorial_editButton_heading': 'Bearbeiten/Speichern',
          'detailScreenTutorial_editButton_message':
              'Mit diesem Button kannst du in den Bearbeitungsmodus wechseln und deine Änderungen speichern. Probier es aus!',
          'detailScreenTutorial_notificationTimesKey_heading': 'Erinnerungen',
          'detailScreenTutorial_notificationTimesKey_message':
              'Die Anzahl der konfigurierbaren Erinnerungen passt sich deinem Tagesziel an.',
          'detailScreenTutorial_notificationTimesKey_tap':
              'Aktivieren/Deaktivieren.',
          'detailScreenTutorial_notificationTimesKey_hold': 'Zeit ändern',
          'detailScreenTutorial_rewardList_heading': 'Belohnungen',
          'detailScreenTutorial_rewardList_message':
              'Hier siehst du alle aktiven Belohnungen für deine Gewohnheit.',
          'homeScreenTutorial_details_heading': 'Details',
          'homeScreenTutorial_details_message':
              'Tippe jetzt auf die Gewohnheit, um Details anzuzeigen.',
          'detailScreenTutorial_statistics_heading': 'Statistiken',
          'detailScreenTutorial_statistics_message':
              'Hier siehst du auf einen Blick, wie oft du diese Gewohnheit in letzter Zeit abgeschlossen hast.',
          'detailScreenTutorial_statistics_hold': 'Mehr Details',
          'completionStepTutorial_complete_heading': 'Abschließen',
          'completionStepTutorial_complete_message':
              'Schließe jetzt das Tagesziel ab, um eine Belohnung zu erhalten!',
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
              'Hinweis: Du kannst eine Zahlenspanne z.B. 2-5 eingeben, um deine Belohnung spannender zu machen!',
          'invalid_range_title': 'Ungültige Zahlenspanne',
          'invalid_range_message':
              'Please make sure "min" is not greater than "max"',
          'warning': 'Achtung',
          'times_per_day': 'Wie oft pro Tag?',

          'notification_times': 'Erinnerungen',
          'rewards': 'Belohnungen',
          'reward_missing_warning': 'Bitte wähle mindestens eine Belohnung.',
          "no_rewards_caption" : "Du hast noch keine Belohnungen.",
          'create_reward_button' : 'Erstellen',
          'schedule': 'Zeitplan',
          'missing_schedule_warning': 'Bitte wähle mindestens einen Tag.',
          //Rewardpopup Screen
          'streak_message': 'Das ist dein @streak Abschluss in Folge!',
          'motivational_message': 'Weiter so!',
          //Habit detail screen
          'save_habit': 'Speichern',
          'edit_habit': 'Bearbeiten',
          'per_day': 'pro Tag',
          'delete_habit': 'Löschen',
          'Week': 'Woche ',
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
