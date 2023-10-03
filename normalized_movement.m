function filteredData = normalized_movement(video_filename)
    % Create a VideoReader object to read the video file
    video = VideoReader(video_filename);
    
    % Read all the frames from the video into a 4D array
    video_frames = read(video);
 %%    %%%%%%%%%%%%%ROI Frame%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   first_frame = video_frames(:,:,:,1);
   num_frames = size(video_frames, 4);
    % Display the first frame and select ROI
   imshow(first_frame);
   % Get the current figure handle
    fig = gcf;

    % Set the figure size (adjust as needed)
    set(fig, 'Position', [400, 400, 400, 400]);
   % Set the figure size (adjust as needed)
   title('Select ROI and press Enter');
   roi = drawrectangle;
   wait(roi); % Wait for user to confirm selection by pressing Enter
   roi_pos = round(roi.Position); % Round to nearest integers
   video_frames_roi = cell(1, num_frames);
   close(gcf);
   for i = 1:num_frames
    % Crop the current frame to ROI and store it in video_frames_roi
    video_frames_roi{i} = imcrop(video_frames(:,:,:,i), roi_pos);
   end
   video_frames_roi = cat(4, video_frames_roi{:});
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
   gray_frames = zeros(size(video_frames_roi, 1), size(video_frames_roi, 2), num_frames);
    
    % Loop over each frame
    for i = 1:num_frames
        % Convert the current frame to grayscale and store it in the gray_frames array
        gray_frames(:, :, i) = rgb2gray(video_frames_roi(:, :, :, i));
    end
    
    % Get the number of frames
    num_frames = size(gray_frames, 3);
    
    % Initialize an array to hold the rescaled frames
    rescaled_frames = zeros(size(gray_frames));
    
    % Loop over each frame
    for i = 1:num_frames
        % Get the current frame
        frame = gray_frames(:, :, i);
    
        % Rescale the pixel values to the range [0, 1]
        frame = frame - min(frame(:));
        frame = frame / max(frame(:));
    
        % Store the rescaled frame in the rescaled_frames array
        rescaled_frames(:, :, i) = frame;
    end
    binary_frames=rescaled_frames;
    %% %%%%%%%%%%%%%%%Filtering Part%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize an array to hold the number of white pixels for each frame
    white_pixels = zeros(1, num_frames);
    
    % Loop over each frame
    for i = 1:num_frames
        % Get the current frame
        current_frame = binary_frames(:, :, i);
    
        % Count the number of white pixels in the current frame
        num_white_pixels = sum(current_frame(:));
    
        % Store the number of white pixels in the white_pixels array
        white_pixels(i) = num_white_pixels;
    end
    
    % Set the number of frames to process
    num_frames_to_process = num_frames;
    mean_diff=mean(abs(diff(white_pixels)));
    windowSize = 4;  % adjust this value as needed

    % Create the filter coefficients for the moving average filter
    b = (1/windowSize)*ones(1, windowSize);
    a = 1;
    
    % Apply the filter to your data
    filteredData = filter(b, a, white_pixels);
    plot1=plot(filteredData);
    display(plot1)