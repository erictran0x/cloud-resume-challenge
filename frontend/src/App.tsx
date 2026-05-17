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
        <Resume.Topic label="Education">
          <Resume.Subtopic
            label="University of California, San Diego - B.S. Computer Science"
            dateFrom="Jun 2021">
          </Resume.Subtopic>
        </Resume.Topic>
        <Resume.Topic label="Certifications">
          <Resume.Subtopic
            label="Linux Foundation Certified Kubernetes Application Developer"
            link="https://drive.google.com/file/d/1QqK2Z9TwfKzZYlu5wI2Pd42yoG4ygVOg/view"
            dateFrom="Jan 2026" />
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
            label="ITG Stamina Database"
            link="https://d2xk0hpalqd86m.cloudfront.net/"
            dateFrom="Nov 2025"
            dateTo="present">
            <p>
              A web app using React, HTML, CSS, and JavaScript/TypeScript
              to centralize all StepMania/In The Groove stamina simfiles to a single website
              and analyze them to determine the difficulty ratings of future simfiles.
              &nbsp;<a href="https://github.com/erictran0x/itg-stamdb">source code</a>
            </p>
            <ul>
              <li>
                Built a simfile parser in Python
                and developed the REST API using Lambda (serverless compute) integrated by API Gateway
                to serve the parsed data stored in S3 (object storage) and DynamoDB (NoSQL) to the user
                at a high variable traffic scale and zero idle infra cost.
              </li>
              <li>
                Applied Agile methodologies to personal project development,
                integrating CI/CD pipelines with AWS cloud and Terraform (IaC, DevOps) using GitHub Actions
                to ensure the site updates as soon as possible when a code change is committed to the Git repository.
              </li>
              <li>
                Integrated GitHub Copilot (AI)
                to scaffold React components to reduce manual boilerplate,
                allowing me to shift focus from simple block building to core architecture and roll out new features more quickly.
              </li>
            </ul>
          </Resume.Subtopic>
          <Resume.Subtopic
            label="The Cloud Resume Challenge - this website!"
            dateFrom="Oct 2025"
            dateTo="Nov 2025">
            <p>
              A digital version of this resume using React, HTML, CSS, and TypeScript
              to be able to fit more information that normally would not fit on a traditional one-page document.
              &nbsp;<a href="https://github.com/erictran0x/cloud-resume-challenge">source code</a>
            </p>
            <ul>
              <li>
                Created a real-time view counter using API Gateway websockets, DynamoDB Streams, and Lambda running in Python
                to log the number of times the site has been visited by various recruiters or those simply curious.
              </li>
            </ul>
          </Resume.Subtopic>
        </Resume.Topic>
        <Resume.Topic label="Work Experience">
          <Resume.Subtopic
            label="Tata Consultancy Services - Software Developer"
            dateFrom="Nov 2021"
            dateTo="Feb 2024">
            <ul>
              <li>
                Led an Agile team in the end-to-end development of a web app
                using the MEAN stack (MongoDB, Express.js, and Angular), HTML, CSS, and JavaScript,
                scheduling daily standup meetings and sprint planning to discuss project updates and current tasks
                to ensure delivery of the product from 0 to 1 two weeks ahead of schedule.
              </li>
              <li>
                Engineered an end-to-end automation framework with Python and Mobly
                to integrate hardware-software interactions for Android TV's Google Assistant functionality,
                reducing manual testing time from 4 hours to 40 minutes per testing device on average.
              </li>
              <li>
                Optimized automation workflows by refactoring an OCR-based system to ADB (Android Debug Bridge) system-call architecture,
                improving automated test time performance from 12 hours to under 1 hour,
                eliminating operational overhead caused by image processing.
              </li>
            </ul>
          </Resume.Subtopic>
        </Resume.Topic>
        <Resume.Topic label="Skills">
          <p><b>Programming Languages:</b> JavaScript/TypeScript, Python</p>
          <p><b>Frameworks:</b> React, Vue, Express.js, socket.io</p>
          <p><b>Databases:</b> MySQL, MongoDB, DynamoDB</p>
          <p><b>Infrastructure:</b> Docker, Terraform, Kubernetes, Amazon Web Services</p>
          <p>Other: Git, GitHub Actions, Agile Development</p>
        </Resume.Topic>
      </Resume>
      <ViewerCount />
    </>
  )
}

export default App
