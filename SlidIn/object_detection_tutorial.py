
# coding: utf-8

# # Object Detection Demo
# Welcome to the object detection inference walkthrough!  This notebook will walk you step by step through the process of using a pre-trained model to detect objects in an image. Make sure to follow the [installation instructions](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md) before you start.

# # Imports

# In[1]:


import numpy as np
import os
import six.moves.urllib as urllib
import sys
import tarfile
import tensorflow as tf
import zipfile
import cv2
import datetime
import telepot
import threading
import time


from collections import defaultdict
from io import StringIO
from PIL import Image





class TelegramSender(object):

    picPath = None
    token = '620726290:AAFbFVXBhmy9uTOLdZLYqxbyg5j_eA8sKR4'
    bot = None
    isText = True
    text = ''
    
    def __init__(self, interval=1):
        """ Constructor
        :type interval: int
        :param interval: Check interval, in seconds
        """
        self.interval = interval
        self.bot = telepot.Bot(token)

    def sendText(self):
      chat_id = "492169246"
      try :
        self.bot.sendMessage(chat_id,self.text)
      except:
        print('cannot send tex')
    def sendPicture(self):

        
        chat_id = "492169246"
        try :
          print(self.picPath)
          pic = open(self.picPath,'rb')
          self.bot.sendPhoto(chat_id, pic, self.text)
        except:
          print('cannot send pic')
    def startText(self,text):
        self.isText = True
        self.text = text
        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True
        thread.start() 
    def start(self,path,text):
        self.isText = False
        self.text = text
        self.picPath = path
        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True
        thread.start() 
    def run(self):
        if self.isText == True:
          self.sendText()
        else:
          self.sendPicture()
######################################ENDCLASS

cap = cv2.VideoCapture('IMG_0527.MOV')#('RUPP.mov')

# This is needed since the notebook is stored in the object_detection folder.
sys.path.append("..")
from object_detection.utils import ops as utils_ops

if tf.__version__ < '1.4.0':
  raise ImportError('Please upgrade your tensorflow installation to v1.4.* or later!')


from utils import label_map_util

from utils import visualization_utils as vis_util



# What model to download.
MODEL_NAME = 'ssdlite_mobilenet_v2_coco_2018_05_09'
MODEL_FILE = MODEL_NAME + '.tar.gz'
DOWNLOAD_BASE = 'http://download.tensorflow.org/models/object_detection/'

# Path to frozen detection graph. This is the actual model that is used for the object detection.
PATH_TO_CKPT = MODEL_NAME + '/frozen_inference_graph.pb'

# List of the strings that is used to add correct label for each box.
PATH_TO_LABELS = os.path.join('data', 'mscoco_label_map.pbtxt')

NUM_CLASSES = 5


def takeImage(path,text):

    
    dateString=datetime.datetime.now().strftime("%I_%M_%S%p_%B_%d_%Y")
    imName = path+'PICTURE/img'+dateString+'.png'
    cv2.imwrite(imName, input_frame)
    tel = TelegramSender()
    tel.start(imName,text)

def takeImageAndShow(path):

    
    dateString=datetime.datetime.now().strftime("%I_%M_%S%p_%B_%d_%Y")
    imName = path+'PICTURE/img'+dateString+'.png'
    cv2.imwrite(imName, input_frame)
    cv2.imshow('saved to '+imName,input_frame)
    tel = TelegramSender()
    tel.start(imName,'saved '+imName)
      
    


def openFileDialog():
  path = easygui.fileopenbox()
  print(path)
def footer(x,y,w,h,frame):
  alpha = 0.8
  fx = x
  fy = y
  overlay = frame.copy()
  cv2.rectangle(overlay,(fx,fy),(fx+w,fy+h),(0,10,120),-1)
  cv2.addWeighted(overlay, alpha, frame, 1 - alpha, 0, frame);
  cv2.circle(frame,(fx,fy+70), 70, (0,20,130), -1)

  cv2.putText(
      frame,
      'Royal University of Phnom Penh',
      (fx-20, fy+40),
      font,
      0.6,
      (250, 250, 250),
      2,
      cv2.FONT_HERSHEY_SIMPLEX,
      )
  cv2.putText(
      frame,
      'CopyRight - RoboticsLab 2018',
      (fx-30, fy+70),
      font,
      0.6,
      (250, 250, 250),
      2,
      cv2.FONT_HERSHEY_SIMPLEX,
      )
  cv2.putText(
      frame,
      'People Counter',
      (fx-20, fy+110),
      font,
      1,
      (255, 255, 255),
      2,
      cv2.FONT_HERSHEY_SIMPLEX,
      )
 
def roundedText(x,y,w,h,frame,text):
  alpha = 0.8
  fx = x
  fy = y
  overlay = frame.copy()
  cv2.rectangle(overlay,(fx,fy),(fx+w,fy+h),(0,10,120),-1)
  cv2.addWeighted(overlay, alpha, frame, 1 - alpha, 0, frame);
  cv2.circle(frame,(fx,fy+int(h/2)), int(h/2), (0,10,120), -1)
  cv2.circle(frame,(fx+w,fy+int(h/2)), int(h/2), (0,10,120), -1)
  cv2.putText(
      frame,
      text,
      (fx, fy+int(h/2)+3),
      font,
      0.5,
      (250, 250, 250),
      1,
      cv2.FONT_HERSHEY_SIMPLEX,
      )
def resizeImg(frame,scalePercent):
  scale_percent = scalePercent
  Rwidth = int(frame.shape[1] * scale_percent)
  Rheight = int(frame.shape[0] * scale_percent)
  dim = (Rwidth, Rheight)
  # resize image
  frame = cv2.resize(frame, dim, interpolation = cv2.INTER_AREA)
  return frame
def resize(frame,dim):
  # resize image
  frame = cv2.resize(frame, dim, interpolation = cv2.INTER_AREA)
  return frame


#opener = urllib.request.URLopener()
#opener.retrieve(DOWNLOAD_BASE + MODEL_FILE, MODEL_FILE)
tar_file = tarfile.open(MODEL_FILE)
for file in tar_file.getmembers():
 file_name = os.path.basename(file.name)
 if 'frozen_inference_graph.pb' in file_name:
   tar_file.extract(file, os.getcwd())

## Load a (frozen) Tensorflow model into memory

detection_graph = tf.Graph()
with detection_graph.as_default():
  od_graph_def = tf.GraphDef()
  with tf.gfile.GFile(PATH_TO_CKPT, 'rb') as fid:
    serialized_graph = fid.read()
    od_graph_def.ParseFromString(serialized_graph)
    tf.import_graph_def(od_graph_def, name='')


# ## Loading label map
# Label maps map indices to category names, so that when our convolution network predicts `5`, we know that this corresponds to `airplane`.  Here we use internal utility functions, but anything that returns a dictionary mapping integers to appropriate string labels would be fine

# In[ ]:


label_map = label_map_util.load_labelmap(PATH_TO_LABELS)
categories = label_map_util.convert_label_map_to_categories(label_map, max_num_classes=NUM_CLASSES, use_display_name=True)
category_index = label_map_util.create_category_index(categories)

# In[ ]:
graph = detection_graph 
with graph.as_default():
      sess = tf.Session(graph=graph)
      # Get handles to input and output tensors
      ops = tf.get_default_graph().get_operations()
      all_tensor_names = {output.name for op in ops for output in op.outputs}
      tensor_dict = {}
      for key in [
          'num_detections', 'detection_boxes', 'detection_scores',
          'detection_classes', 'detection_masks'
      ]:
        tensor_name = key + ':0'
        if tensor_name in all_tensor_names:
          tensor_dict[key] = tf.get_default_graph().get_tensor_by_name(
              tensor_name)
      if 'detection_masks' in tensor_dict:
        # The following processing is only for single image
        detection_boxes = tf.squeeze(tensor_dict['detection_boxes'], [0])
        detection_masks = tf.squeeze(tensor_dict['detection_masks'], [0])
        # Reframe is required to translate mask from box coordinates to image coordinates and fit the image size.
        real_num_detection = tf.cast(tensor_dict['num_detections'][0], tf.int32)
        detection_boxes = tf.slice(detection_boxes, [0, 0], [real_num_detection, -1])
        detection_masks = tf.slice(detection_masks, [0, 0, 0], [real_num_detection, -1, -1])
        detection_masks_reframed = utils_ops.reframe_box_masks_to_image_masks(
            detection_masks, detection_boxes, image.shape[0], image.shape[1])
        detection_masks_reframed = tf.cast(
            tf.greater(detection_masks_reframed, 0.0), tf.uint8)
        # Follow the convention by adding back the batch dimension
        tensor_dict['detection_masks'] = tf.expand_dims(
            detection_masks_reframed, 0)
      image_tensor = tf.get_default_graph().get_tensor_by_name('image_tensor:0')

      total_passed_vehicle = 0
      speed = "waiting..."
      direction = "waiting..."
      size = "waiting..."
      color = "waiting..."
      counting_mode = "..."
      width_heigh_taken = True
      roi = 400
      width = 1280
      height = 720
      fps = 30
      is_color_recognition_enabled = 0
      realCounter = 0
      offset = 0
      sOffset = 0

      scale = 0.3
      ret, image = cap.read()
      image_np = image#load_image_into_numpy_array(image)
      input_frame = image
      input_frame = resizeImg(input_frame,scale)
      h, w, c = input_frame.shape
      height = int(h)
      width = int(w)
      roi = int(width/2)

while True:
  
  ret, image = cap.read()
  image_np = image#load_image_into_numpy_array(image)
  input_frame = image

  input_frame = resizeImg(input_frame,scale)
  h, w, c = input_frame.shape
  height = int(h)
  width = int(w)
  
## roi = int(height/2)
##  center = (w / 2, h / 2)
##  M = cv2.getRotationMatrix2D(center, -90, 0.5)
##  input_frame = cv2.warpAffine(input_frame, M, (h, w))


  
  # Expand dimensions since the model expects images to have shape: [1, None, None, 3]
  image_np_expanded = np.expand_dims(input_frame, axis=0)
  # Actual detection.
  output_dict = sess.run(tensor_dict, feed_dict={image_tensor: image_np_expanded})

      # all outputs are float32 numpy arrays, so convert types as appropriate
  output_dict['num_detections'] = int(output_dict['num_detections'][0])
  output_dict['detection_classes'] = output_dict['detection_classes'][0].astype(np.uint8)
  output_dict['detection_boxes'] = output_dict['detection_boxes'][0]
  output_dict['detection_scores'] = output_dict['detection_scores'][0]
  if 'detection_masks' in output_dict:
    output_dict['detection_masks'] = output_dict['detection_masks'][0]
 

  # Visualization of the results of a detection.
  boxes = output_dict['detection_boxes']
  classes = output_dict['detection_classes']
  scores = output_dict['detection_scores']
  
##  vis_util.visualize_boxes_and_labels_on_image_array(
##      image_np,
##      output_dict['detection_boxes'],
##      output_dict['detection_classes'],
##      output_dict['detection_scores'],
##      category_index,
##      instance_masks=output_dict.get('detection_masks'),
##      use_normalized_coordinates=True,
##      line_thickness=8)
 

  # insert information text to video frame
  font = cv2.FONT_HERSHEY_SIMPLEX

               # Visualization of the results of a detection.        
  counter, csv_line, counting_mode = vis_util.visualize_boxes_and_labels_on_image_array_x_axis(cap.get(1),
                                                                                                             input_frame,
                                                                                                              1,
                                                                                                             is_color_recognition_enabled,
                                                                                                             np.squeeze(boxes),
                                                                                                             np.squeeze(classes).astype(np.int32),
                                                                                                             np.squeeze(scores),
                                                                                                             category_index,
                                                                                                             x_reference = roi,
                                                                                                             deviation=10,
                                                                                                             use_normalized_coordinates=True,
                                                                                                             line_thickness=1)
  
  
  
  # when the vehicle passed over line and counted, make the color of ROI line green
  if realCounter != counter:
    realCounter = counter
    if realCounter == 1:
      total_passed_vehicle = total_passed_vehicle + counter
      
  if counter == 1:                  
                cv2.line(input_frame, (roi, 0), (roi, height), (0, 0xFF, 0), 2)
  else:
                cv2.line(input_frame, (roi, 0), (roi, height), (0, 0, 0xFF), 2)

                total_passed_vehicle = total_passed_vehicle + counter

  
  # insert information text to video frame


  input_frame = resizeImg(input_frame,3)
##  h, w, c = input_frame.shape
##  input_frame = cv2.copyMakeBorder(input_frame,0,200,200,200,cv2.BORDER_REFLECT,value=(255,255,255))


  
  h, w, c = input_frame.shape

  
  font = cv2.FONT_HERSHEY_SIMPLEX
  fx = 10
  fy = 20
  alpha = 0.9
  overlay = input_frame.copy()
  cv2.rectangle(overlay,(fx-10,fy),(fx+310,fy+140),(100,100,100),-1)
  cv2.addWeighted(overlay, alpha, input_frame, 1 - alpha, 0, input_frame);
  cv2.circle(input_frame,(fx+300,fy+70), 70, (120,120,120), -1)
  cv2.putText(
      input_frame,
      'Detected count: ',
      (fx+10, fy+40),
      font,
      0.8,
      (255, 255, 255),
      2,
      cv2.FONT_HERSHEY_SIMPLEX,
      )
  cv2.putText(
      input_frame,
      str(total_passed_vehicle),
      (fx+260,fy+90),
      font,
      1.8,
      (0, 0xFF, 0xFF),
      4,
      cv2.FONT_HERSHEY_SIMPLEX,
      )

  dateString=datetime.datetime.now().strftime("%B %d, %Y")
  timeString=datetime.datetime.now().strftime("%I:%M%p")
  cv2.putText(
      input_frame,
      'Time: '+timeString,
      (fx+10, fy+80),
      font,
      0.8,
      (255, 255, 255),
      2,
      cv2.FONT_HERSHEY_SIMPLEX,
      ) 
  cv2.putText(
      input_frame,
      'Date: '+dateString,
      (fx+10, fy+120),
      font,
      0.5,
      (255, 255, 255),
      2,
      cv2.FONT_HERSHEY_SIMPLEX,
      )

  
  footer(w-300,fy,300,140,input_frame)
  roundedText(50,h-50,240,40,input_frame,'Press Enter to take a picture')
  roundedText(340,h-50,400,40,input_frame,'Press Arrow key to adjust detect line( <- , -> )')
  roundedText(w-100,h-50,100,40,input_frame,'V 1.0.0')
 
  if total_passed_vehicle - sOffset >= 5:
    t = TelegramSender()
    dateString=datetime.datetime.now().strftime("%I:%M:%S %p %B/%d/%Y")
    txt = 'Now ' +dateString+'\nHey! I am PeopleCounter!\n'+str(total_passed_vehicle)+' people are detected\n I will send you a picture every 10 detect count!\nthank you!'
    t.startText(txt)
    sOffset=total_passed_vehicle
  if total_passed_vehicle - offset >= 10:
    dateString=datetime.datetime.now().strftime("%I:%M:%S %p %B/%d/%Y")
    takeImage('./',dateString)
    offset = total_passed_vehicle

    
  cv2.imshow('People Counter v1.0',input_frame)
  key = (cv2.waitKey(25) & 0xFF)
  #print(key)
  if key == ord('q'):
    cv2.destroyAllWindows()
    break
  if key == 119:
    roi = int(roi + 0.1 * roi)
    if roi >= width:
      roi = width
  if key == 115:
    roi = int(roi - 0.1 * roi)
    if roi <=  0:
      roi = 0
  if key == 13:
    try:
      openfile = fileopenbox("Welcome", "COPR", filetypes= "*.txt")
    except:
      print("error")
      takeImageAndShow('./') 
    
      
##    app = QApplication(sys.argv)
##    ex = App()
##    ex.openFileNameDialog(app)
##    sys.exit(app.exec_())



        

