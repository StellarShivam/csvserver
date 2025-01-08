
# README.md

This document outlines the steps and commands executed to make the `csvserver` running.

---

## **Steps and Commands**

### **1. Install Docker and docker-compose on your machine and run following commands**
```bash
docker pull infracloudio/csvserver:latest
```

---

### **2. Run the Container and Check Logs**
1. Run the container:
   ```bash
   docker run -d --name csvserver infracloudio/csvserver:latest
   ```
2. Check running containers:
   ```bash
   docker ps
   ```
   No containers were running due to missing `inputdata`.
3. Check logs for the error:
   ```bash
   docker logs csvserver
   ```
   Output:
   ```
   2025/01/08 16:55:25 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory
   ```

---

### **3. Create `gencsv.sh` Script**
1. Write the script:
   ```bash
   nano gencsv.sh
   ```
   Content of `gencsv.sh`:
   ```bash
   #!/bin/bash

   if [ $# -ne 2 ]; then
       echo "Usage: ./gencsv.sh <start_index> <end_index>"
       exit 1
   fi

   start=$1
   end=$2

   if [ $start -ge $end ]; then
       echo "Start index must be less than end index."
       exit 1
   fi

   > inputFile
   for i in $(seq $start $end); do
       echo "$i, $((RANDOM % 1000))" >> inputFile
   done
   ```
2. Make the script executable:
   ```bash
   chmod +x gencsv.sh
   ```
3. Generate `inputFile`:
   ```bash
   ./gencsv.sh 2 8
   ```

---

### **4. Run the Container with `inputFile`**
1. Stop and remove the previous container:
   ```bash
   docker stop csvserver
   docker rm csvserver
   ```
2. Run the container:
   ```bash
   docker run -d --name csvserver -v "$(pwd)/inputFile:/csvserver/inputdata" infracloudio/csvserver:latest
   ```

---

### **5. Check the Application Port**
1. Get shell access to the container:
   ```bash
   docker exec -it csvserver /bin/sh
   ```
2. Check the port:
   ```bash
   netstat -tuln
   ```
   Output:
   ```
   tcp6       0      0 :::9300                 :::*                    LISTEN
   ```
3. Exit the container:
   ```bash
   exit
   ```
4. Stop and remove the container:
   ```bash
   docker stop csvserver
   docker rm csvserver
   ```

---

### **6. Run the Container on Port 9393 with Environment Variable**
1. Run the container:
   ```bash
   docker run -d --name csvserver \
   -v "$(pwd)/inputFile:/csvserver/inputdata" \
   -p 9393:9300 \
   -e CSVSERVER_BORDER=Orange \
   infracloudio/csvserver:latest
   ```
2. Verify the container is running:
   ```bash
   docker ps
   ```
   Output:
   ```
   CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                    NAMES
   e03ed85d7ef7   infracloudio/csvserver:latest   "/csvserver/csvserver"   12 seconds ago   Up 11 seconds   0.0.0.0:9393->9300/tcp   csvserver
   ```
3. Access the application:
   Run http://localhost:9393 on your browser and will see this as shown in picture OR exec this command
   ```bash
   curl http://localhost:9393
   ```
   ![Home Page](https://i.postimg.cc/DwN1LjRF/Screenshot-2025-01-08-230114.png)
---

### **Notes**
- The application is accessible at [http://localhost:9393](http://localhost:9393).
- Follow these instructions to replicate the setup on another machine.
