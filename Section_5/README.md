# Section 5

**Data Persistence & Core Data**

This directory contains code that was completed during Section 5 of the course, which is on "Data Persistence & Core Data". In this directory there is only one subdirectory containing the project that I worked on during the entire duration of this section of the course, that directory being `DreamLister`.

The Dream Lister app works in a similar fashion as "Wish Lists" on Amazon, iTunes, and other online stores. As you can see in the screenshot below, we have three items — my favorite coffee, a mid-century modern desk that I really want, and my dream car, the Tesla Model 3 – and all of them are sorted by newest item first.

![1.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/1.png?raw=true "List of items in Dream Lister app sorted by newest item first")

Using the `UISegmentedControl`, one can also choose to sort these items by cheapest item first; it's coincidence that the ordering is the same when sorted by newest item first and when it is sorted by cheapest item first.

![2.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/2.png?raw=true "List of items in Dream Lister app sorted by cheapest item first")

One can also sort these items in alphabetical order by title.

![3.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/3.png?raw=true "List of items in Dream Lister app sorted alphabetically by title")

When one presses the + button, this screen appears where one can enter the title, price, details, and store of the item.

![4.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/4.png?raw=true "Creating a new item")

Because Swift 3 and Core Data has full Unicode support, one can also insert emojis.

![5.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/5.png?raw=true "Inserting emojis is also possible.")

After tapping the placeholder image for the first time, iOS asks permission to access the user's photos.

![6.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/6.png?raw=true "iOS asks the user for permission to access his/her photo library.")

Upon confirming this request, the app takes the user to his/her camera roll where he/she can select an image.

![7.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/7.png?raw=true "Creating a new item")

After pressing the "Save Item" button at the bottom of the screen (not shown), the information is written off to Core Data, and displayed in the main screen. One can also tap on an item, which takes them to the edit screen, which is populated with that item's information, and then tap the red trash can in the upper right hand corner to delete the item. Upon tapping this, the user is presented with an Action Sheet asking the user for confirmation as to whether or not to delete this item.

![8.png](https://github.com/ahuber1/iOS-Portfolio/blob/master/Section_5/screenshots/8.png?raw=true "Deleting an item")

Like the other apps, I improved this app, even though I was not told to in the course.

1. I added a timestamp to the bottom of each thumbnail on the main screen.

2. Although this is not shown in the screenshots, I also changed the Return button to a Next button on the keyboard for the top two text fields, and a Done button on the keyboard for the last text field. Pressing the Next button will select the next field, and pressing the done button will dismiss the keyboard.

3. I changed the capitalize settings for the first text field to the "Words" setting, and the last field to the "Sentences" setting.

4. I changed the keyboard type for the second text field to decimal.

5. I added an Input Accessory View to the keyboard for all three text fields. On the left is a Previous button, a space 10 pixels wide, a Next button, and a flexible space that aligns the final button, the Done button, to the right. The Previous and Next buttons take the user to the previous and next fields (if there are any), and the Done button dismisses the keyboard. Note that the Previous button is enabled only if there is a previous text field to go to, and the Next button is enabled only if there is a next text field to go to.

6. The Action Sheet shown in the last screenshot was another addition I made.
