% Auto-generated by cameraCalibrator app on 26-Sep-2023
%-------------------------------------------------------


% Define images to process
imageFileNames = {'/MATLAB Drive/Calibration/image1.tif',...
    '/MATLAB Drive/Calibration/image2.tif',...
    '/MATLAB Drive/Calibration/image3.tif',...
    '/MATLAB Drive/Calibration/image4.tif',...
    '/MATLAB Drive/Calibration/image5.tif',...
    '/MATLAB Drive/Calibration/image6.tif',...
    '/MATLAB Drive/Calibration/image7.tif',...
    '/MATLAB Drive/Calibration/image8.tif',...
    '/MATLAB Drive/Calibration/image9.tif',...
    '/MATLAB Drive/Calibration/image10.tif',...
    };
% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 24;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')