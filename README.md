# SFPhotoPicker
模仿QQ聊天页面选择器
----------2017.4.28----------
<h2>The demo function show</h2>
<h4>项目效果展示</h4>

![image](https://github.com/jufengliushao/SFPhotoPicker/blob/master/screen-pict/result-1.png)

![image](https://github.com/jufengliushao/SFPhotoPicker/blob/master/screen-pict/result-2.gif)

<h1>How to use</h1>
<h4>怎么使用</h4>
<h2>1.import the follow files(导入以下文件)</h2>

![image](https://github.com/jufengliushao/SFPhotoPicker/blob/master/screen-pict/code-list.png)

<p><b>ThridTool:</b>this document contains GPUImage/SFHelper/Masonry/MBProgressHUD, which help to the project(项目中使用的第三方，可以根据需求进行选择添加)</p>
<p><b>SFPhotoMain:</b></p>
<p>SFCamera: camera function files(相机功能)</p>
<p>SFPhotoPicker: photo picker function files(图片选择功能)</p>
<p>SFPhotoModel: photo-info model files(图片信息model)</p>
<p>SFPhotoTool: photo-select-index model files(图片选择功能)</p>
<p><b>SFPhotoPickerHelper.pch:</b>.pch file</p>
<p><b>SFPhotoPickerHeader.h:</b>.h assmet file</p>
<p><b>SFViewPropertyHelper.h:</b>.h assmet file</p>

<h2>2.coding (代码实现)</h2>
<h3>2.1 sfphoto-picker realize (SFPhotoPicker 实现)</h3>

<p>this header is a controller which you can use navigation to push and select photos in library(这是一个controller，你可以使用此控制器实现本地图片的选择功能)</p>
<ul>
<li><p><b><i>import this header: </i></b>#import "SFPhotoAlbumListViewController.h"</p></li>
<dt>this header is a controller which you can use navigation to push and select photos in library(这是一个controller，你可以使用此控制器实现本地图片的选择功能)</dt>
<li><p><b><i>add key in info.plist</i></b></p></li>
<dt>add the key <i><b>Privacy - Photo Library Usage Description</b></i> and the value, which type is string, to ask user photo-album right(添加<i><b>Privacy - Photo Library Usage Description</b></i> key，要求获取手机相册权限)</dt>
<li><p><b><i>ask the photo-album right first</i></b></p></li>
<dt>asking photo-album right first before you select photos, using the follwing coding(在选择本地图片之前，首先要求获取相册使用权限)
</dt>
</ul>

```objc
SFPhotoPickerTool *_tool = [SFPhotoPickerTool sharedInstance];
[_tool sf_askPhotoRight:^(PHAuthorizationStatus stat) {
         dispatch_async(dispatch_get_main_queue(), ^{
             // coding
         });
    }];
```
<h4>get the selected pictures</h4>
<p>you can use the coding, which follwing, to get the photo-model array</p>

```objc
// @property (nonatomic, strong, readonly) __kindof NSArray <SFPhotoAssetInfoModel *>*selectedIndexImgArr;
[SFIndexCalculateTool shareInstance].selectedIndexImgArr
```

<p>you also can use the method in <b><i></i>SFIndexCalculateTool</b> to complete your-own project</p>

![image](https://github.com/jufengliushao/SFPhotoPicker/blob/master/screen-pict/des-photoGet-2.png)

<h3><i>Waring</i></h3><p>must clean the selected arrary when you need to select-picture again(the coding follow)</p>

```objc
/**
 清除所有选中的数据
 * warning 在不选择数据的时候记得清空，否则数据会一直显示
 */
- (void)sf_clearAllCalculateCache;
```

```objc
[[SFIndexCalculateTool shareInstance] sf_clearAllCalculateCache];
```

<h3>2.2 SFCamera usage</h3>
<h4>SFCamera 使用</h4>
<ul>
<li><p>add key<b><i> Privacy - Camera Usage Description </i></b>in info.plist</p></li>
<li><p><b><i>request camera-right first</i></b></p></li>
<dt><p>get the camera-right-status</p></dt>
</ul>
init for SFCameraTool

```objc
SFCameraTool *_cameraTool = [SFCameraTool sharedInstance];
```

get camera-right-status

```objc
AVAuthorizationStatus status = [_cameraTool sf_askCameraRightStuts];
```
ask right of camera

```objc
[_cameraTool sf_askCameraRight:^(AVAuthorizationStatus status) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [self judgementCameraRightStatus:status];
       });
    }];
```

<ul>
<li><b>take pictures</b></li>
<dt>
<p><b><i>focusing</i></b>: signal click the screen, the camera'll focusing auto.</p>
<p><b><i>zooming</i></b>: PinchGesture.</p>
</dt>
<li>camera functions
<ul>
<li>the flash aotu or open when you need</li>
<li>the background-front camera can be changed</li>
</ul>
</li>
</ul>

the flashing opening always 强制开启闪光灯

```objc
[[SFCameraTool sharedInstance] sf_openDeviceFlash];
```

close flash forever 强制关闭闪光灯

```objc
[[SFCameraTool sharedInstance] sf_closeDeviceFlash];
```

auto-flashing 闪光灯自动

```objc
[[SFCameraTool sharedInstance] sf_setDeviceFlashAuto];
```

transfrom camera position 切换摄像头

```objc
[[SFCameraTool sharedInstance] sf_switchCameraposition];
```

<ul>
<li>take phots 拍照</li>
</ul>

shutter codes 快门按钮代码

```objc
[[SFCameraTool sharedInstance] sf_cameraShutterComplete:^(UIImage *img, NSError *err) {
         // add your codes
        [[SFCameraTool sharedInstance] sf_cameraStopRunning]; // stop the camera running, if not take photo
    }];
```

<ul>
<li>save photo in album</li>
<dt>



</dt>
</ul>
