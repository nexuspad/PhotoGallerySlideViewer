PhotoGallerySlideViewer
=======================

A iPhone demo app with photo slider effect.

We use the same method in NexusApp after some intensive researching and we want to share this with the community.

Keep in mind the code is for demo purpose only. And you are welcome to make any changes to fit your own needs.

Some tips on reading the code:

1. PhotoGalleryCollectionViewController is the main screen that shows thumbnails. We use UICollectionView for images. It also serves as a delegate to provide the image at specific index.

2. LightboxViewController is the screen to show big images. It's opened when tn is touched on the collection view and it initialises a customized scrollview (NPScrollView) for displaying photos that can be viewed in sliding effect. It also serves as delegate to provide the previous or next UIImageViews to NPScrollView when things start to move.

3. The NPScrollView is actually where the magic happens. It has 3 pages (usually) and by sliding the screen the previous/next photo comes on to display. It also calls its delegate to get the previous or next view to fill in the left or right spot during the action.

Notice that self.showsHorizontalScrollIndicator = YES is there for demonstration purpose.


* NPScrollView is designed to take any UIView. In reality most images are served online, and a customized UIImageView such as SDWebImage can be used to provide the data.


The code is inspired by these examples:
https://developer.apple.com/library/ios/samplecode/StreetScroller/Introduction/Intro.html
