for part in msg.walk():
    print(part.get_content_type())
from email.iterators import _structure
for part in msg.walk():
    print(part.get_content_maintype() == 'multipart',
          part.is_multipart())







_structure(msg)
