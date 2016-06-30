using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Mail;
using System.Net;
using System.Xml;
using System.IO;
using System.Collections;
using System.Net.Mime;

namespace Sempra.Confirm.InBound.Comm
{
    public class Emailer
    {
        private const string PROJ_FILE_NAME = "FaxEmailer";
        private int timeOut = 100000;

        public int TimeOut
        {
            get { return timeOut; }
            set { timeOut = value; }
        }

        public void SendToFaxGateway(string smtpServer, string fromAddr,string faxGatewayEmailAddr, FaxRequest request, string requestFilePath)
        {

            ValidateRequest(request);
            CreateRequestFile(request, requestFilePath);
            SmtpClient smtpClient = new SmtpClient(smtpServer);
            smtpClient.Host = smtpServer;
          
            MailMessage message  = new MailMessage(fromAddr,faxGatewayEmailAddr);
            GetAttachments(message,request, requestFilePath);
<<<<<<< HEAD
            string ticketNum = request.AppReference.ToString();
            message.Subject = SentConfirmEmailSubject;//"Fax Request";
            message.Body = SentConfirmEmailBody;
=======
            message.Subject = "Fax Request";
>>>>>>> Hotfix-1.0.0
            smtpClient.Send(message);
            message.Dispose();
            
        }

        public void Send(string smtpServer, string fromAddr, string toAddr, string subject, string body, string[] fileList)
        {
            ValidateFiles(fileList);

            SmtpClient smtpClient = new SmtpClient(smtpServer);
            smtpClient.Host = smtpServer;

            MailMessage message = new MailMessage(fromAddr, toAddr, subject, body);
            GetAttachments(message, fileList);
            smtpClient.Send(message);
            message.Dispose();

        }

        private void ValidateFiles(string[] fileList)
        {

            if (fileList == null) { return; };

            for (int i = 0; i < fileList.Length; ++i)
            {
                if (!File.Exists(fileList[i]))
                {
                    throw new Exception("The attachment file " + fileList[i] + " does not exist." + Environment.NewLine +
                        "Error CNF-375 in " + PROJ_FILE_NAME + ".ValidateFiles().");
                }
            }

        }

        private void GetAttachments(MailMessage message, string[] fileList)
        {
            if (fileList == null) { return; };

            for (int i = 0; i < fileList.Length; ++i)
            {
                Attachment attchment = new Attachment(fileList[i]);
                message.Attachments.Add(attchment);
            }

        }
        private void GetAttachments(MailMessage message, FaxRequest request, string requestFilePath)
        {
            
            Attachment attachment = new Attachment(requestFilePath + "request.xml");
            message.Attachments.Add(attachment);            
            foreach (var doc in request.Documents)
            {                
                if (doc != null)
                {
                    var stream = new MemoryStream(doc.DocumentContents);

                    var documentFileName = doc.DocumentFileName;
                    if (!".TIF".Equals(Path.GetExtension(documentFileName), StringComparison.InvariantCultureIgnoreCase))
                    {
                        documentFileName = Path.ChangeExtension(documentFileName, ".tif");
                    }
                    Attachment att = new Attachment(stream, documentFileName, "image/tiff");
                    message.Attachments.Add(att);                                        
                }
            }

        }

        private void ValidateRequest(FaxRequest request)
        {
            if (request == null)
            {
                throw new Exception("Request is empty." + Environment.NewLine +
                    "Error CNF-376 in " + PROJ_FILE_NAME + ".ValidateRequest().");
            }
            if  (request.AppCode == null || "".Equals(request.AppCode) )
            {
                throw new Exception("App Code is empty." + Environment.NewLine +
                    "Error CNF-377 in " + PROJ_FILE_NAME + ".ValidateRequest().");
            }
            if (request.AppSender == null || "".Equals(request.AppSender))
            {
                throw new Exception("App Sender is empty." + Environment.NewLine +
                    "Error CNF-378 in " + PROJ_FILE_NAME + ".ValidateRequest().");
            }
            if (request.AppReference == null || "".Equals(request.AppReference))
            {
                throw new Exception("App Reference is empty." + Environment.NewLine +
                    "Error CNF-379 in " + PROJ_FILE_NAME + ".ValidateRequest().");
            }
            if (request.Documents.Count <= 0)
            {
                throw new Exception("No document is found to attach." + Environment.NewLine +
                    "Error CNF-380 in " + PROJ_FILE_NAME + ".ValidateRequest().");
            }

            IList<AttachDocument> documents = request.Documents;
            foreach (AttachDocument doc in documents)
            {                
                if (doc == null)
                {
                    throw new Exception("Invalid attached document" + Environment.NewLine +
                    "Error CNF-381 in " + PROJ_FILE_NAME + ".ValidateRequest().");
                }
                if (doc.TotalPages <= 0)
                {
                    throw new Exception("Invalid value for Total pages for the attached document." + Environment.NewLine +
                    "Error CNF-382 in " + PROJ_FILE_NAME + ".ValidateRequest().");
                }
                if (string.IsNullOrEmpty(doc.DocumentFileName))
                {
                    throw new Exception("The attached document can not be null" + Environment.NewLine +
                    "Error CNF-383 in " + PROJ_FILE_NAME + ".ValidateRequest().");
                }

                if (doc.DocumentContents == null)
                {
                    throw new Exception("The attachement file " + doc.DocumentFileName + " does not exist." + Environment.NewLine +
                    "Error CNF-384 in " + PROJ_FILE_NAME + ".ValidateRequest().");
                }
            }

            if (request.FaxNumber == null || "".Equals(request.FaxNumber))
            {
                if (request.SendMethod.Equals("FAX"))
                {
                    throw new Exception("Fax Number is empty" + Environment.NewLine +
                    "Error CNF-385 in " + PROJ_FILE_NAME + ".ValidateRequest().");
                }
            }

            if (request.EmailAddress == null || "".Equals(request.EmailAddress))
            {
                if (request.SendMethod.Equals("EMAIL"))
                {
                    throw new Exception("Email Address is empty" + Environment.NewLine +
                    "Error CNF-386 in " + PROJ_FILE_NAME + ".ValidateRequest().");
                }
            }

            if ( request.Recipient == null || "".Equals(request.Recipient))
            {
                throw new Exception("The recipient is empty." + Environment.NewLine +
                    "Error CNF-387 in " + PROJ_FILE_NAME + ".ValidateRequest().");
            }

        }
        private void CreateRequestFile(FaxRequest request, string path)
        {
            string requestFile = path + "Request.xml";
            string xmlData = GetRequestXML(request);
            StreamWriter writer = new StreamWriter(requestFile);
            writer.Write(xmlData);
            writer.Close();

        }
        private string GetRequestXML(FaxRequest request)
        {
            StringWriter stringWriter = new StringWriter();
            XmlWriter writer = new XmlTextWriter(stringWriter);
            writer.WriteStartElement("Transmission");
            writer.WriteElementString("app_code",GetXmlStringValue(request.AppCode));
            stringWriter.Write('\n');
            writer.WriteElementString("app_ref",GetXmlStringValue(request.AppReference));
            stringWriter.Write('\n');
            writer.WriteElementString("app_sender", GetXmlStringValue(request.AppSender));
            stringWriter.Write('\n');
            writer.WriteElementString("replay_to_email_address", GetXmlStringValue(request.ReplayToEmailAddress));
            stringWriter.Write('\n');
            WriteCallbackAction(request.ReceiptAction, writer, "receipt");
            
            writer.WriteStartElement("documents");
            
            IList<AttachDocument> documents = request.Documents;
            foreach (var doc in documents)
            {                
                if (doc != null)
                {
                    writer.WriteStartElement("document");
                    writer.WriteAttributeString("location", doc.Location);
                    writer.WriteAttributeString("total_pages", doc.TotalPages.ToString());
                    writer.WriteValue(GetFileName(doc.DocumentFileName));
                    writer.WriteEndElement();
                    stringWriter.Write('\n');
                }
            }
            writer.WriteEndElement();
            stringWriter.Write('\n');
            writer.WriteStartElement("transmit_instructions");
            writer.WriteStartElement("sendto");
            writer.WriteAttributeString("cover_required", "N");
            writer.WriteElementString("method", request.SendMethod);
            stringWriter.Write('\n');
            writer.WriteElementString("country_code", GetXmlStringValue(request.CountryCode));
            stringWriter.Write('\n');
            writer.WriteElementString("area_code", GetXmlStringValue(request.AreaCode));
            stringWriter.Write('\n');
            writer.WriteElementString("local_number", GetXmlStringValue(request.FaxNumber));
            stringWriter.Write('\n');
            writer.WriteElementString("email", GetXmlStringValue(request.EmailAddress));
            stringWriter.Write('\n');
            writer.WriteElementString("recipient", GetXmlStringValue(request.Recipient));
            stringWriter.Write('\n');
            string actionString = GetActionString(request);
            if (actionString != null) 
            {
                writer.WriteRaw(actionString);
                stringWriter.Write('\n');
            }            
            stringWriter.Write('\n');
            writer.WriteEndElement();
            stringWriter.Write('\n');
            writer.WriteEndElement();
            stringWriter.Write('\n');
            
            if (request.Vault.Name != null && !"".Equals(request.Vault.Name))
            {
                writer.WriteStartElement("vault_instructions");
                writer.WriteElementString("vault_name", GetXmlStringValue(request.Vault.Name));
                stringWriter.Write('\n');
                writer.WriteStartElement("vauld_doc_data");
                writer.WriteElementString("onbehalfofuser", GetXmlStringValue(request.Vault.OnBehalfofUser));
                stringWriter.Write('\n');
                writer.WriteElementString("title", GetXmlStringValue(request.Vault.Title));
                stringWriter.Write('\n');
                writer.WriteElementString("author", GetXmlStringValue(request.Vault.Author));
                stringWriter.Write('\n');
                writer.WriteElementString("desc", GetXmlStringValue(request.Vault.Description));
                stringWriter.Write('\n');
                Hashtable docProps = request.Vault.VaultIndex;

                if (docProps.Count > 0)
                {
                    writer.WriteStartElement("vault_index");
                    IDictionaryEnumerator enumerator = docProps.GetEnumerator();
                    while (enumerator.MoveNext())
                    {
                        string key = (string) enumerator.Key;
                        string val = (string)enumerator.Value;

                        writer.WriteStartElement("index");
                        writer.WriteAttributeString("id", GetXmlStringValue(key));
                        writer.WriteValue(GetXmlStringValue(val));
                        writer.WriteEndElement();
                        stringWriter.Write('\n');
                    }
                    writer.WriteEndElement();
                    stringWriter.Write('\n');
                 
                }
            }

            writer.WriteEndElement();
            stringWriter.Write('\n');  
            stringWriter.Flush();
            String returnString = stringWriter.ToString();
            writer.Close();
            stringWriter.Close();
            return returnString;
        }

        private string GetActionString(FaxRequest request)
        {
            using (var sw = new StringWriter())
            {

                using (var writer = new XmlTextWriter(sw))
                {                    
                    if (request.Action != null)
                    {
                        writer.WriteStartElement("actions");
                        writer.WriteStartElement("action");

                        WriteCallbackAction(request.Action.SuccessAction, writer, "onsuccess");
                        WriteCallbackAction(request.Action.FailureAction, writer, "onfail");

                        writer.WriteEndElement();
                        writer.WriteEndElement();
                        return sw.ToString();
                    }
                }
            }
            return null;
        }

        private void WriteCallbackAction(CallbackAction callbackAction, XmlWriter writer, string tagName)
        {
            if (!CallbackAction.IsNullOrInvalid(callbackAction))
            {
                writer.WriteStartElement(tagName);
                writer.WriteAttributeString("method", callbackAction.MethodType);
                writer.WriteValue(GetXmlStringValue(callbackAction.MethodValue));
                writer.WriteEndElement();            
            }
        }

        private string GetFileName(string fullFileName)
        {
            FileInfo file = new FileInfo(fullFileName);
            string fileName = file.Name;
            return fileName;
        }

        private string GetXmlStringValue(string text)
        {
            return text;
        }
    }
}
