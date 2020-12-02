# Install required packages
# install.packages("readxl")
# install.packages('ggplot2')
# install.packages('gganimate')

# Import libraries
library("readxl")
library(ggplot2)
library(gganimate)

# Read Excel file
df<-read_excel("C:\\Users\\profi\\Documents\\UNSW Civil Engineering\\Year 4\\T3\\Research Thesis CVEN4951\\Waymo Data\\Extracted_Data\\training_0002.tar\\lesgo\\Frame Data (0002_11392) OK (3 to 2 veh; 5 to 40kmh)\\birds_eye_data (complete).xlsx", sheet = 'Raw')

# Obtain number of frames in video, and x-axis thresholds
frame_num <- max(df$Frame)
lane_min <-min(df$center_x)
lane_max <-max(df$center_x)

# Assign colours to legend
colors <- c("TYPE_AV" = "red", "TYPE_VEHICLE" = "blue", "TYPE_SIGN" = "green", "TYPE_CYCLIST" = "yellow", "TYPE_PEDESTRIAN" = "orange")

# Inputs/Parameters
frame = 194 # Options: 1, 2, ..., frame_num

# Plot birds eye view image (png) for a frame
p <- ggplot(data = subset(df, Frame==frame), aes(x = center_x, y = center_y, colour = type)) +
  geom_point(show.legend = TRUE, alpha = 0.5, size=3, aes(colour = type)) +
  labs(x = "x-Distance (m)", y = "y-Distance (m)", colour =  'OBJECT') +
  annotate("segment", x=lane_min, xend=lane_max, y=1.85, yend=1.85, colour='black', size=1, alpha=0.8) +
  annotate("segment", x=lane_min, xend=lane_max, y=-1.85, yend=-1.85, colour='black', size=1, alpha=0.8) +
  theme(legend.position = 'bottom') +
  scale_color_manual(values = colors)
title_p <- 'Birds Eye View'
ggsave(paste(title_p, ' (Frame ', frame, ' of ', frame_num,').png', sep = ""), plot = p + ggtitle(title_p, subtitle = paste('Frame ', frame, ' of ', frame_num, sep="")))#

# Plot birds eye view animation (gif) for all frames in video
# Sourced from: https://www.datanovia.com/en/blog/gganimate-how-to-create-plots-with-beautiful-animation-in-r/
p <- ggplot(df, aes(x = center_x, y = center_y, colour = type)) +
  geom_point(show.legend = TRUE, alpha = 0.5, size=3, aes(colour = type)) +
  labs(x = "x-Distance (m)", y = "y-Distance (m)", colour = 'OBJECT') +
  annotate("segment", x=lane_min, xend=lane_max, y=1.85, yend=1.85, colour='black', size=1, alpha=0.8) +
  annotate("segment", x=lane_min, xend=lane_max, y=-1.85, yend=-1.85, colour='black', size=1, alpha=0.8) +
  scale_color_manual(values = colors) +
  theme(legend.position = 'bottom')
title_p <- "Birds Eye View"
anim <- p +
  transition_time(Frame) +
  ggtitle(paste(title_p, sep=""), subtitle='Frame {frame} of {nframes} ({round(progress*20, 1)}s)')
anim1 <- animate(plot = anim,
                 nframes = frame_num,
                 fps=10)
anim_save(paste(title_p, '.gif', sep=""), anim1)