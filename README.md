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
<dt>asking photo-album right first before you select photos, using the follwing coding in the picture(在选择本地图片之前，首先要求获取相册使用权限)

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
[SFIndexCalculateTool shareInstance].selectedIndexImgArr
```

<p>you also can use the method in <b><i></i>SFIndexCalculateTool</b> to complete your-own project</p>

![image](https://github.com/jufengliushao/SFPhotoPicker/blob/master/screen-pict/des-photoGet-2.png)
