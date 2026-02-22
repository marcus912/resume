# Technical Quick Reference - Google CE Interview

## GCP Services Cheat Sheet

### Compute
| Service | Use Case | Key Features |
|---------|----------|--------------|
| **Compute Engine** | VMs | Custom machine types, preemptible VMs, sole tenancy |
| **GKE** | Kubernetes | Autopilot mode, node auto-provisioning |
| **Cloud Run** | Serverless containers | Scale to zero, pay per request |
| **Cloud Functions** | Event-driven functions | Gen 2 (Cloud Run based), triggers |
| **App Engine** | PaaS | Standard (sandboxed) vs Flexible (containers) |

### AI/ML (YOUR STRENGTH AREA)
| Service | Use Case |
|---------|----------|
| **Vertex AI** | End-to-end ML platform - training, deployment, MLOps |
| **Vertex AI Generative AI** | Gemini models, embeddings, grounding |
| **Vertex AI Search** | Enterprise search with RAG built-in |
| **Vertex AI Agents** | Conversational AI (your chatbot experience!) |
| **BigQuery ML** | ML in SQL - great for analysts |
| **AutoML** | No-code ML model training |
| **Pre-trained APIs** | Vision, Language, Speech, Translation |

### Storage
| Service | Use Case | Durability |
|---------|----------|------------|
| **Cloud Storage** | Object storage (like S3) | 99.999999999% |
| **Persistent Disk** | Block storage for VMs | Regional or zonal |
| **Filestore** | NFS file shares | Managed NFS |
| **Local SSD** | High-performance ephemeral | Data lost on stop |

### Databases
| Service | Type | Best For |
|---------|------|----------|
| **Cloud SQL** | Managed MySQL/PostgreSQL/SQL Server | Traditional apps |
| **Cloud Spanner** | Globally distributed SQL | Global scale + ACID |
| **Firestore** | Document DB | Mobile/web apps |
| **Bigtable** | Wide-column NoSQL | IoT, time-series, analytics |
| **Memorystore** | Redis/Memcached | Caching |
| **AlloyDB** | PostgreSQL compatible | High-performance OLTP |

### Networking
| Service | Function |
|---------|----------|
| **VPC** | Virtual network, subnets, firewall rules |
| **Cloud Load Balancing** | Global L4/L7 load balancing |
| **Cloud CDN** | Content delivery |
| **Cloud DNS** | Managed DNS |
| **Cloud NAT** | Outbound NAT for private instances |
| **Cloud Interconnect** | Dedicated connection to on-prem |
| **Cloud VPN** | Site-to-site VPN |

---

## Networking Fundamentals

### OSI Model (MEMORIZE THIS)
```
7. Application   - HTTP, DNS, FTP (what the user sees)
6. Presentation  - SSL/TLS, encryption, compression
5. Session       - Session management, authentication
4. Transport     - TCP/UDP, ports, flow control
3. Network       - IP, routing, ICMP
2. Data Link     - Ethernet, MAC addresses, ARP
1. Physical      - Cables, signals, NICs
```

### TCP 3-Way Handshake
```
Client          Server
  |--- SYN ------->|     (I want to connect)
  |<-- SYN-ACK ----|     (OK, I acknowledge)
  |--- ACK ------->|     (Great, connection established)
```

### TCP vs UDP
| TCP | UDP |
|-----|-----|
| Connection-oriented | Connectionless |
| Reliable delivery | Best effort |
| Ordered packets | No ordering |
| Flow control | No flow control |
| Use: HTTP, SSH, DB | Use: DNS, video streaming, games |

### Common Ports
```
22   - SSH
53   - DNS
80   - HTTP
443  - HTTPS
3306 - MySQL
5432 - PostgreSQL
6379 - Redis
8080 - Alt HTTP
```

### DNS Record Types
| Type | Purpose | Example |
|------|---------|---------|
| A | IPv4 address | example.com -> 192.168.1.1 |
| AAAA | IPv6 address | example.com -> 2001:db8::1 |
| CNAME | Alias | www.example.com -> example.com |
| MX | Mail server | example.com -> mail.example.com |
| TXT | Text (verification) | SPF, DKIM, domain verification |
| NS | Nameserver | example.com -> ns1.google.com |
| SRV | Service location | _http._tcp.example.com |

### HTTP Status Codes
```
2xx - Success
  200 OK
  201 Created
  204 No Content

3xx - Redirect
  301 Moved Permanently
  302 Found (temp redirect)
  304 Not Modified

4xx - Client Error
  400 Bad Request
  401 Unauthorized (authentication)
  403 Forbidden (authorization)
  404 Not Found
  429 Too Many Requests

5xx - Server Error
  500 Internal Server Error
  502 Bad Gateway
  503 Service Unavailable
  504 Gateway Timeout
```

---

## Linux Debugging Commands

### Process & CPU
```bash
# List processes
ps aux | grep <process>
top / htop

# Process tree
pstree -p

# Trace system calls
strace -p <pid>
strace -f <command>

# CPU profiling
perf top
perf record -g <command>
perf report
```

### Memory
```bash
# Memory usage
free -h
vmstat 1

# Process memory
pmap <pid>
cat /proc/<pid>/maps

# Memory stats
cat /proc/meminfo
```

### Disk & I/O
```bash
# Disk usage
df -h
du -sh *

# I/O statistics
iostat -x 1
iotop

# File system
lsof +D /path
```

### Network
```bash
# Connections
netstat -tuln
ss -tuln

# DNS lookup
dig example.com
dig +trace example.com
nslookup example.com

# Connectivity
ping -c 4 host
traceroute host
mtr host

# Packet capture
tcpdump -i eth0 port 80
tcpdump -i any host 10.0.0.1

# HTTP debugging
curl -v https://example.com
curl -I https://example.com  # headers only
```

### Logs
```bash
# System logs
journalctl -u <service>
journalctl -f  # follow
dmesg | tail

# Common log locations
/var/log/syslog
/var/log/messages
/var/log/auth.log
```

---

## Kubernetes Debugging

### Basic Commands
```bash
# Cluster info
kubectl cluster-info
kubectl get nodes

# Workload status
kubectl get pods -A
kubectl get pods -o wide
kubectl describe pod <pod>

# Logs
kubectl logs <pod>
kubectl logs <pod> -c <container>
kubectl logs -f <pod>  # follow
kubectl logs --previous <pod>  # crashed container

# Execute in container
kubectl exec -it <pod> -- /bin/sh

# Debug container
kubectl debug <pod> -it --image=busybox
```

### Common Issues & Solutions

**Pod stuck in Pending**
```bash
kubectl describe pod <pod>
# Check: Resources, node selector, tolerations, PVC
```

**Pod in CrashLoopBackOff**
```bash
kubectl logs <pod> --previous
kubectl describe pod <pod>
# Check: Exit code, OOM, missing config
```

**Service not reachable**
```bash
kubectl get endpoints <service>
kubectl describe service <service>
# Check: Selector matches pod labels
```

**DNS issues**
```bash
kubectl exec -it <pod> -- nslookup kubernetes
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

---

## Troubleshooting Scenarios

### "Application is slow"
1. **Where** is it slow? (client, network, app, DB)
2. **Metrics**: latency percentiles (p50, p95, p99)
3. **Check**:
   - Network latency (ping, traceroute)
   - App response time (logs, APM)
   - DB query performance (slow query log)
   - Resource saturation (CPU, memory, I/O)
   - Connection pooling
   - Caching hit rates

### "Can't connect to service"
1. **DNS**: Can you resolve the hostname?
2. **Network**: Can you reach the IP/port?
3. **Firewall**: Are ports open?
4. **Service**: Is the service running?
5. **Auth**: Are credentials correct?

```bash
# Step-by-step
dig service.example.com
ping <ip>
telnet <ip> <port>
curl -v http://<ip>:<port>/health
```

### "Container keeps crashing"
1. Check exit code (`kubectl describe pod`)
2. Check logs (`kubectl logs --previous`)
3. Check resources (OOMKilled?)
4. Check health checks
5. Check dependencies (DB, other services)

---

## Distributed Systems Concepts

### CAP Theorem
- **Consistency**: All nodes see same data
- **Availability**: Every request gets a response
- **Partition tolerance**: System works despite network splits

**You can only have 2 of 3.** Most distributed systems choose AP or CP.

### Cloud Spanner's Approach
Uses TrueTime (GPS + atomic clocks) to achieve external consistency while remaining available. It's "effectively CP" but with high availability through synchronous replication.

### Consistency Models
| Model | Description |
|-------|-------------|
| Strong | Read always returns latest write |
| Eventual | Read will eventually return latest |
| Causal | Causally related ops seen in order |
| Read-your-writes | You see your own writes |

### Common Patterns
- **Circuit Breaker**: Stop calling failing services
- **Retry with backoff**: Exponential backoff + jitter
- **Bulkhead**: Isolate failures
- **Timeout**: Don't wait forever
- **Idempotency**: Same request = same result

---

## GKE Specific Knowledge

### Autopilot vs Standard
| Autopilot | Standard |
|-----------|----------|
| Google manages nodes | You manage nodes |
| Pay per pod | Pay per node |
| Less control | Full control |
| Best for most workloads | For specific needs |

### Common GKE Issues
1. **Insufficient quota**: Check project quotas
2. **Node pool scaling**: Check autoscaler config
3. **Networking**: VPC-native vs routes-based
4. **Workload Identity**: Service account mapping

---

## Interview Tips

### When Asked to Debug
1. **Clarify** the problem (symptoms, when started, what changed)
2. **Isolate** the component (is it network, app, DB?)
3. **Gather data** (logs, metrics, traces)
4. **Form hypothesis** and test
5. **Fix** and **verify**
6. **Document** (postmortem)

### When Asked to Design
1. **Clarify requirements** (scale, latency, consistency)
2. **Start simple**, then add complexity
3. **Draw the architecture** (even verbally describe it)
4. **Discuss trade-offs** (cost, complexity, performance)
5. **Address failure modes**
