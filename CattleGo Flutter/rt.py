import cv2
import requests

URL = "https://superstrenuous-marcelina-overeffusively.ngrok-free.dev/predict-frame"

cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    _, img_encoded = cv2.imencode('.jpg', frame)
    files = {'file': ('frame.jpg', img_encoded.tobytes(), 'image/jpeg')}

    response = requests.post(URL, files=files)
    print(response.json())

    cv2.imshow('Webcam', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()