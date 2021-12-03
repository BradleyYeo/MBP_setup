import pdftotext

with open("/Users/bradleyyeo/Documents/SMT203/As1/SMT203_A1.pdf","rb") as input:
	with open("test.txt", "a") as output:
		pdf = pdftotext.PDF(input)
		for page_num, page in enumerate(pdf):
			result = "\n\n".join(pdf)
			output.write(result)

