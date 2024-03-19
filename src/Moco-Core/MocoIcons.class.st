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
GXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAA0hJREFUOBF1U2tIFFEUvvPY2bdb
u4q5ZrqVWZYvNGMrs6AspSAoMOmHERVBCJF/irJ+VJCRJkoZPcBYCntqSVQsRZb00DDX1Mi2Wl9r
u7Y2+5hxZmdnpnuXFvzTB9+cy7nn++ZwzgwmyzL4DzCYT4DUQXogGUiEBZAV0RMA7eS/w+yQ3+/x
1rwcGd047PuD/55hxdS4OFVOYoJn8+JFtgS12lF6+86paY4DH/ZWOmcbkKP+4KWjrzp33xt2qiWC
wAEGm0ANyhLARDFZg9sP16yxEh6GYf08H31pzAAfmJp6VHa3bf0EH9aYjaZQVV4WscJkGlQSeIDm
+Az76JjJ5hjAj73qUgAxYkidY/Ajh6hBkOerd7Z1FCPx/rwctq7IekZLkq3wfi2kfjzEVj4fdyeu
s1hku9MZ7QiJEZCB/mpv30lnIKjdnrmMvbKhqJzmhfTj/Z+HWlxjIiMIqtclxYobThcAAmybJAEm
KQBFEMqYwdZmR7+MkaR0dnXhM5jEy9+8O2330RqcJEWjSiM5/EHQurEYGEgClMw3P4E1A0gM8RW4
g8Fm4lydnGtrpeFKS9tHxoewWw/lXHtXaJLje2HuQqfX9yn5fgePX7NJT11jX9DqY8Th5FOQVaoh
Du3953AgaAEAA0eWWLTVQ9/T9/V9OWg1Gurr8nM9MI3Zvn5D9YuQBoE0KCka2oEplkULi0/RqCaB
JFquOV1cFx3Qwjts17z4A9Z44zMgSfsHfT4B1i2E/A4J8KXxpjdGSsH0uifVEyG2ojQ56fJynYbp
ck+qAMdheinCp+u0jl8zrBmIItATBOqURWIEHPLxvtxsXAiHqdPvP+wxKJU9L7ZsON9ckB2ozcqI
vN20riNVp7nZOvxjPRDCoCQlGU2/D4mjQMMY9fsvzm9oChG19XLVy9fMFMvVwfwqyMywKB5qcgzS
ROOViL6xmXPR9PXYAFHE0ANC0e12d26/+yDHywsapVIZXmk2z2gpCuv1eHEvw+hUGAjf21bmKVu8
MAvWR79CJIwZoDM14g80NHb37GnpHwB+IaJG/4ICxyKb09K4E2utHwuS5u2EdT5UHMNsg1guRZCk
Hc7p6UJWENUZprlDOopqh5c9sYLZ8S/zZYqy0M8x0AAAAABJRU5ErkJggg=='
]

{ #category : #'instance creation' }
MocoIcons class >> new [
	^ self error: 'MocoIcons should not be instantiated.'
]
