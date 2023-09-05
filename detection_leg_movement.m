function peak_time_frames = detection_leg_movement(video_filename,status)
    % Specify the filename of the video
    parameter=3.2;% This parameter can be changed if the detection is troublesome, but 3-3.5 should be the best for the current task

   %declare the parameter that may influence the detection of time:

    % Create a VideoReader object to read the video file
    video = VideoReader(video_filename);
    
    % Read all the frames from the video into a 4D array
    video_frames = read(video);
    
    % The resulting array will have dimensions (height, width, 3, num_frames)
    % where height and width are the dimensions of each frame, 3 is the number of color channels (RGB), and num_frames is the total number of frames in the video
    
    % Get the number of frames
    num_frames = size(video_frames, 4);
    
    % Initialize an array to hold the grayscale frames
    gray_frames = zeros(size(video_frames, 1), size(video_frames, 2), num_frames);
    
    % Loop over each frame
    for i = 1:num_frames
        % Convert the current frame to grayscale and store it in the gray_frames array
        gray_frames(:, :, i) = rgb2gray(video_frames(:, :, :, i));
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
    
    threshold = 0.95;
    binary_frames = imbinarize(rescaled_frames, threshold);
    
    
    % Initialize an array to hold the filtered binary frames
    filtered_frames = zeros(size(binary_frames));
    
    % Loop over each frame, starting from the second frame
    for i = 2:num_frames
        % Get the current frame and the previous frame
        current_frame = binary_frames(:, :, i);
        previous_frame = binary_frames(:, :, i-1);
    
        % Compute the difference between the current and previous frames
        diff_frame = abs(double(current_frame) - double(previous_frame));
    
        % Store the difference frame in the filtered_frames array
        filtered_frames(:, :, i) = diff_frame;
    end
    
    
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
    
    % Initialize an array to hold the peak time frames
    peak_time_frames = zeros(1, num_frames_to_process);
    
    % Loop over each frame, starting from the second frame
    for i = 2:num_frames_to_process-1
        % Get the current, previous, and next number of white pixels
        current_white_pixels = white_pixels(i);
        next_white_pixels = white_pixels(i+1);
        diff_white_pixels=abs(next_white_pixels-current_white_pixels);
        if diff_white_pixels>parameter*mean_diff
            peak_time_frames(1,i)=1;
        end
    end
    %% 
    if status ==1
    % Create a VideoReader object to read the video file
    video = VideoReader(video_filename);
    
    % Read all the frames from the video into a 4D array
    video_frames = read(video);
    
    % Get the number of frames
    num_frames = size(video_frames, 4);
    
    % Initialize an array to hold the annotated frames
    annotated_frames = video_frames;
    
    % Loop over each frame
    for i = 1:num_frames
        % Check if the current frame is a peak time frame
        if peak_time_frames(i) == 1
            % Annotate the current frame and the next 9 frames with "Leg Movement"
            for j = i:min(i+20, num_frames)
                annotated_frames(:, :, :, j) = insertText(annotated_frames(:, :, :, j), [20 20], 'Leg Movement', 'FontSize', 15, 'BoxColor', 'white', 'BoxOpacity', 0.3);
            end
        end
    end
    %%
    %%%%%%%%% create a annotated video version%%%%%%%%%%%%%%%%%%%%%%
    % Create a VideoWriter object to write the annotated video to a file
    annotated_video = VideoWriter('annotated_video.avi');
    
    % Open the VideoWriter object
    open(annotated_video);
    
    % Write the annotated frames to the video file
    writeVideo(annotated_video, annotated_frames);
    
    % Close the VideoWriter object
    close(annotated_video);
    % Play the annotated video using implay function
    implay('annotated_video.avi');
    end
end



