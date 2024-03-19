"
Stores Moco icons.
"
Class {
	#name : #MocoIcons,
	#superclass : #Object,
	#category : #'Moco-Core-Ui'
}

{ #category : #accessing }
MocoIcons class >> mocoIcon [
	^ Form fromBinaryStream: self mocoIconContents base64Decoded asByteArray readStream
]

{ #category : #'private - accessing' }
MocoIcons class >> mocoIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAdhAAAHYQGVw7i2AAAA
GXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAtVJREFUOBFtU1uITlEUXmtfzv//
c1EeBiNJyhORS8qLlOR+yVBuDZGGSU0ZTR7UNC4jEgb5GWO8EFHKaPAkHhTiAckrcisz5DIz//nP
3mtZ+8z8Qladfc751lrfXnutbyMzw/8MW1oUWFsFZCvAq2/c3NhTisPW1mpFqlYhPsB/CTKtrZO8
inaB0osAsSpNYgLw9BHYd3mkE9ZhOSE8RoCW3wRhRxOV7WNjd7M2CpSS0tRbQOgFoNHg/Sh0DsA5
D+S7hXhZIDClsnSm4jwbs4ltNADaHiETneVtte9Lfsznx6tY1yGqBkiKy4QkdaUEev+hOsxkQvIX
0pn5vGPzk+DFzs5KwGwVYPGD1mUX2CZjpKwYmTJQlGMBg8Fjx3LamL2yOyir1vv6zU+w/WI1lmfz
mB2+VKIUezuHIienCTnUw0Q96J0UQV+N7o8XQJQdgajvJ/V1d/DatRyW5e6DiSaANv2S8VolZh5h
4ZJyDJ6TW7xzx7vAFUwhq1nSbWCDN1LkJ20BrSeAsQ9ZR2Np1aKJZEwbKrucNJ5Fq/Np3NAirebq
8I2Mb8JbGKfKH7CCo2BNE3bdy0PO9zFn1gr+DREX46lTo0NsMCUj6oMgJqbKFGH+ETqsElqCxcIu
dPE2GOC1vH7hd4l5CkRovJ2YxgYCZnwuoPhodgDJFc+BS2JOCrVQLCh5pO/J5+BT5Ew6Pk4GZ5hi
yt8UkSTo/Do8fmYcb934kp2bK4m3oVB8xPFAA29Y2YUdl0dykswQIYmU4ueBMFiqRLP/4Gmw0XbR
wTPK6gVcX/9p0D24Ynu7RYdXZZMVnMTXqbGhpuRPheTLs426L54pc56u2L7QbfmThPqu0P/QAFMU
cINUOU2k3Eux21lKDu8/78IwrTMdMsLVMn85sKTJeIeCAL1/5RJXw3uaXqXg0PKboARGBw7PZKY1
kjxZ9JET/K2MqNsnhSvc3Cy36W/7BSG+WZIjUCuYAAAAAElFTkSuQmCC'
]

{ #category : #'instance creation' }
MocoIcons class >> new [
	^ self error: 'MocoIcons should not be instantiated.'
]
