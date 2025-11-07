import Resume from './components/Resume'
import ViewerCount from './components/ViewerCount'

function App() {
  return (
    <>
      <Resume>
        <Resume.Name>Eric Tran</Resume.Name>
        <Resume.ContactInfo type="Email"><a href="mailto:erictran0x@gmail.com">erictran0x@gmail.com</a></Resume.ContactInfo>
        <Resume.ContactInfo type="GitHub"><a href="https://github.com/erictran0x/">erictran0x</a></Resume.ContactInfo>
        <Resume.ContactInfo type="LinkedIn"><a href="https://linkedin.com/in/erictran0x/">erictran0x</a></Resume.ContactInfo>
        <br />
        <Resume.Topic label="Objective">
          <p>Automation test engineer is seeking a software/cloud developer role to leverage my skills in web development and cloud computing.</p>
        </Resume.Topic>
        <Resume.Topic label="Skills">
          <p>JavaScript/TypeScript (React, Vue, Express.js, socket.io)</p>
          <p>Python, C++, Java</p>
          <p>MySQL, MongoDB</p>
          <p>Git, GitHub Actions, Docker, Terraform</p>
        </Resume.Topic>
        <Resume.Topic label="Certifications">
          <Resume.Subtopic
            label="AWS Certified Solutions Architect -- Professional"
            link="https://cp.certmetrics.com/amazon/en/public/verify/credential/7022718eda474cc9979d9e4a72418a16"
            dateFrom="Oct 2025" />
          <Resume.Subtopic
            label="AWS Certified Developer -- Associate"
            link="https://cp.certmetrics.com/amazon/en/public/verify/credential/7fe7706b4c824644b714661cc302e05c"
            dateFrom="Aug 2025" />
        </Resume.Topic>
        <Resume.Topic label="Projects">
          <Resume.Subtopic
            label="The Cloud Resume Challenge - this website!"
            dateFrom="Oct 2025"
            dateTo="Nov 2025">
              <p>A digital version of my resume. Hosted on AWS. <a href="https://github.com/erictran0x/cloud-resume-challenge">source code</a></p>
              <ul>
                <li>Built the frontend using <b>React</b> and IaC using <b>Terraform</b></li>
                <li>Frontend hosted on S3, accessible through CloudFront</li>
                <li>Viewer count updated when new API Gateway WebSocket connections</li>
                <li>Viewer count tracked with DynamoDB Streams and Lambda</li>
              </ul>
          </Resume.Subtopic>
        </Resume.Topic>
        <Resume.Topic label="Work Experience">
          <Resume.Subtopic
            label="Tata Consultancy Services, San Jose, CA - Software Developer"
            dateFrom="Nov 2021"
            dateTo="Feb 2024">
              <ul>
                <li>
                  <b><u>Improved automated test time performance</u></b> from 12 hours to under 1 hour
                  using faster tricks utilizing ADB (Android Debug Bridge),
                  migrating from a Tesseract/OCR-based system, while also maintaining test correctness.
                </li>
                <li>
                  <b><u>Offloaded 140/170 test cases</u></b> for Android TV's Google Assistant functionality
                  by automating them using <b>Appium/Selenium</b> and <b>Google's Tesseract API</b>,&nbsp;
                  <b><u>reducing manual testing time</u></b> from 4 hours to 40 minutes on average.
                </li>
              </ul>
          </Resume.Subtopic>
        </Resume.Topic>
        <Resume.Topic label="Education">
          <Resume.Subtopic
            label="University of California, San Diego - B.S. Computer Science"
            dateFrom="Jun 2021">
              <ul>
                <li>
                  Relevant coursework: Software Engineering, Data Structures, Algorithm Design and Analysis
                </li>
              </ul>
          </Resume.Subtopic>
        </Resume.Topic>
      </Resume>
      <ViewerCount />
    </>
  )
}

export default App
